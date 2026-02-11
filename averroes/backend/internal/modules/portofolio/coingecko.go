package portofolio

import (
    "context"
    "encoding/json"
    "errors"
    "net/http"
    "os"
    "path/filepath"
    "strings"
    "sync"
    "time"
)

// CoinGeckoProvider mengambil harga crypto dari CoinGecko Simple Price API
// dan melakukan validasi mapping simbol via /coins/list dengan cache lokal.
type CoinGeckoProvider struct {
    baseURL   string
    client    *http.Client
    ids       map[string]string
    priority  map[string]string
    index     map[string]string
    cache     map[string]cachedPrice
    cachePath string
    cacheTTL  time.Duration
    listOnce  sync.Once
    mu        sync.Mutex
}

type cachedPrice struct {
    value     float64
    expiresAt time.Time
}

type coinGeckoResponse map[string]map[string]float64

type coinListItem struct {
    ID     string `json:"id"`
    Symbol string `json:"symbol"`
    Name   string `json:"name"`
}

type coinListCache struct {
    FetchedAt time.Time         `json:"fetched_at"`
    Symbols   map[string]string `json:"symbols"`
}

func NewCoinGeckoProvider(baseURL string, idsConfig string, priorityConfig string, cachePath string, cacheTTL time.Duration) *CoinGeckoProvider {
    provider := &CoinGeckoProvider{
        baseURL: strings.TrimRight(baseURL, "/"),
        client: &http.Client{
            Timeout: 8 * time.Second,
        },
        ids:       parseIDsConfig(idsConfig),
        priority:  parseIDsConfig(priorityConfig),
        index:     map[string]string{},
        cache:     make(map[string]cachedPrice),
        cachePath: cachePath,
        cacheTTL:  cacheTTL,
    }

    provider.loadOrRefreshCoinList()
    return provider
}

func (p *CoinGeckoProvider) GetPrice(symbol string) (float64, error) {
    symbol = strings.ToUpper(strings.TrimSpace(symbol))
    if symbol == "" {
        return 0, nil
    }

    if price, ok := p.getCached(symbol); ok {
        return price, nil
    }

    id := p.resolveID(symbol)
    if id == "" {
        return 0, errors.New("id coingecko tidak ditemukan")
    }

    price, err := p.fetchPrice(id)
    if err != nil {
        return 0, err
    }

    p.setCached(symbol, price)
    return price, nil
}

func (p *CoinGeckoProvider) resolveID(symbol string) string {
    if id, ok := p.priority[symbol]; ok {
        return id
    }
    if id, ok := p.ids[symbol]; ok {
        return id
    }

    p.loadOrRefreshCoinList()
    if id, ok := p.index[symbol]; ok {
        return id
    }

    // fallback: coba gunakan simbol lower sebagai id (tidak selalu valid)
    return strings.ToLower(symbol)
}

func (p *CoinGeckoProvider) fetchPrice(id string) (float64, error) {
    url := p.baseURL + "/simple/price?ids=" + id + "&vs_currencies=idr"

    req, err := http.NewRequestWithContext(context.Background(), http.MethodGet, url, nil)
    if err != nil {
        return 0, err
    }

    resp, err := p.client.Do(req)
    if err != nil {
        return 0, err
    }
    defer resp.Body.Close()

    if resp.StatusCode != http.StatusOK {
        return 0, errors.New("gagal mengambil harga dari CoinGecko")
    }

    var payload coinGeckoResponse
    if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
        return 0, err
    }

    data, ok := payload[id]
    if !ok {
        return 0, errors.New("data harga tidak ditemukan")
    }

    price, ok := data["idr"]
    if !ok {
        return 0, errors.New("harga idr tidak ditemukan")
    }

    return price, nil
}

func (p *CoinGeckoProvider) getCached(symbol string) (float64, bool) {
    p.mu.Lock()
    defer p.mu.Unlock()

    cached, ok := p.cache[symbol]
    if !ok || time.Now().After(cached.expiresAt) {
        return 0, false
    }

    return cached.value, true
}

func (p *CoinGeckoProvider) setCached(symbol string, value float64) {
    p.mu.Lock()
    defer p.mu.Unlock()

    p.cache[symbol] = cachedPrice{
        value:     value,
        expiresAt: time.Now().Add(60 * time.Second),
    }
}

func (p *CoinGeckoProvider) loadOrRefreshCoinList() {
    p.listOnce.Do(func() {
        if p.cachePath == "" {
            return
        }

        cached, ok := readCoinListCache(p.cachePath)
        if ok && !isCacheExpired(cached.FetchedAt, p.cacheTTL) {
            p.index = cached.Symbols
            return
        }

        list, err := p.fetchCoinList()
        if err != nil {
            if ok {
                p.index = cached.Symbols
            }
            return
        }

        p.index = buildSymbolIndex(list)
        _ = writeCoinListCache(p.cachePath, coinListCache{
            FetchedAt: time.Now(),
            Symbols:   p.index,
        })
    })
}

func (p *CoinGeckoProvider) ForceRefreshCoinList() error {
    if p.cachePath == "" {
        return errors.New("cache path tidak tersedia")
    }

    list, err := p.fetchCoinList()
    if err != nil {
        return err
    }

    p.index = buildSymbolIndex(list)
    return writeCoinListCache(p.cachePath, coinListCache{
        FetchedAt: time.Now(),
        Symbols:   p.index,
    })
}

func (p *CoinGeckoProvider) fetchCoinList() ([]coinListItem, error) {
    url := p.baseURL + "/coins/list"

    req, err := http.NewRequestWithContext(context.Background(), http.MethodGet, url, nil)
    if err != nil {
        return nil, err
    }

    resp, err := p.client.Do(req)
    if err != nil {
        return nil, err
    }
    defer resp.Body.Close()

    if resp.StatusCode != http.StatusOK {
        return nil, errors.New("gagal mengambil daftar koin")
    }

    var list []coinListItem
    if err := json.NewDecoder(resp.Body).Decode(&list); err != nil {
        return nil, err
    }

    return list, nil
}

func buildSymbolIndex(list []coinListItem) map[string]string {
    index := map[string]string{}
    for _, item := range list {
        symbol := strings.ToUpper(strings.TrimSpace(item.Symbol))
        if symbol == "" || item.ID == "" {
            continue
        }
        if _, exists := index[symbol]; !exists {
            index[symbol] = item.ID
        }
    }
    return index
}

func readCoinListCache(path string) (coinListCache, bool) {
    data, err := os.ReadFile(path)
    if err != nil {
        return coinListCache{}, false
    }

    var cache coinListCache
    if err := json.Unmarshal(data, &cache); err != nil {
        return coinListCache{}, false
    }

    if cache.Symbols == nil {
        cache.Symbols = map[string]string{}
    }

    return cache, true
}

func writeCoinListCache(path string, cache coinListCache) error {
    if path == "" {
        return nil
    }

    if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
        return err
    }

    payload, err := json.Marshal(cache)
    if err != nil {
        return err
    }

    return os.WriteFile(path, payload, 0o644)
}

func isCacheExpired(fetchedAt time.Time, ttl time.Duration) bool {
    if fetchedAt.IsZero() {
        return true
    }
    if ttl <= 0 {
        return true
    }
    return time.Since(fetchedAt) > ttl
}

func parseIDsConfig(raw string) map[string]string {
    result := map[string]string{}
    raw = strings.TrimSpace(raw)
    if raw == "" {
        // default mapping minimal
        result["BTC"] = "bitcoin"
        result["ETH"] = "ethereum"
        result["BNB"] = "binancecoin"
        result["SOL"] = "solana"
        result["ADA"] = "cardano"
        result["XRP"] = "ripple"
        result["DOT"] = "polkadot"
        result["DOGE"] = "dogecoin"
        result["MATIC"] = "matic-network"
        return result
    }

    // format: BTC=bitcoin,ETH=ethereum
    pairs := strings.Split(raw, ",")
    for _, pair := range pairs {
        kv := strings.SplitN(strings.TrimSpace(pair), "=", 2)
        if len(kv) != 2 {
            continue
        }
        key := strings.ToUpper(strings.TrimSpace(kv[0]))
        val := strings.TrimSpace(kv[1])
        if key != "" && val != "" {
            result[key] = val
        }
    }

    return result
}

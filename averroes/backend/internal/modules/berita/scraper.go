package berita

import (
	"fmt"
	"log"
	"net/http"
	"strings"
	"sync"
	"time"

	"github.com/PuerkitoBio/goquery"
)

const (
	baseURL       = "https://cryptowave.co.id"
	maxBerita     = 20
	cacheDuration = 30 * time.Minute
	userAgent     = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
)

// Scraper — melakukan scraping berita dari cryptowave.co.id
// Data disimpan di memori (cache) selama 30 menit
type Scraper struct {
	mu        sync.RWMutex
	cache     []BeritaItem
	lastFetch time.Time
}

// NewScraper — buat instance scraper baru
func NewScraper() *Scraper {
	return &Scraper{}
}

// AmbilBerita — mengembalikan daftar berita terbaru.
// Jika cache masih valid (< 30 menit) akan dikembalikan langsung.
// Jika sudah kadaluarsa, akan scrape ulang dari website.
func (s *Scraper) AmbilBerita() ([]BeritaItem, error) {
	s.mu.RLock()
	if len(s.cache) > 0 && time.Since(s.lastFetch) < cacheDuration {
		defer s.mu.RUnlock()
		return s.cache, nil
	}
	s.mu.RUnlock()

	items, err := s.scrapeSemuaBerita()
	if err != nil {
		// Jika gagal scrape tapi ada cache lama, kembalikan cache
		s.mu.RLock()
		defer s.mu.RUnlock()
		if len(s.cache) > 0 {
			log.Printf("[berita] gagal scrape, gunakan cache lama: %v", err)
			return s.cache, nil
		}
		return nil, fmt.Errorf("gagal mengambil berita: %w", err)
	}

	s.mu.Lock()
	s.cache = items
	s.lastFetch = time.Now()
	s.mu.Unlock()

	return items, nil
}

// scrapeSemuaBerita — scrape hingga maxBerita dari halaman listing
func (s *Scraper) scrapeSemuaBerita() ([]BeritaItem, error) {
	var allItems []BeritaItem
	page := 1

	for len(allItems) < maxBerita {
		url := baseURL
		if page > 1 {
			url = fmt.Sprintf("%s/?page=%d", baseURL, page)
		}

		items, err := s.scrapeHalamanListing(url)
		if err != nil {
			if page == 1 {
				return nil, err
			}
			break
		}

		if len(items) == 0 {
			break
		}

		allItems = append(allItems, items...)
		page++

		// Jeda antar request supaya tidak membebani server
		time.Sleep(500 * time.Millisecond)
	}

	if len(allItems) > maxBerita {
		allItems = allItems[:maxBerita]
	}

	return allItems, nil
}

// scrapeHalamanListing — scrape satu halaman listing dan ambil artikel
func (s *Scraper) scrapeHalamanListing(url string) ([]BeritaItem, error) {
	doc, err := s.fetchDocument(url)
	if err != nil {
		return nil, err
	}

	var items []BeritaItem
	seen := make(map[string]bool)

	// Cari semua link artikel
	doc.Find("a[href]").Each(func(i int, sel *goquery.Selection) {
		href, exists := sel.Attr("href")
		if !exists {
			return
		}

		// Filter hanya link artikel
		if !strings.Contains(href, "/articles/") {
			return
		}

		// Ekstrak slug
		slug := extractSlug(href)
		if slug == "" || seen[slug] {
			return
		}
		seen[slug] = true

		// Ambil judul dari teks link atau elemen anak
		judul := strings.TrimSpace(sel.Text())

		// Coba cari heading di dalam link
		if heading := sel.Find("h1, h2, h3, h4").First(); heading.Length() > 0 {
			judul = strings.TrimSpace(heading.Text())
		}

		// Skip jika judul kosong atau terlalu pendek
		if len(judul) < 10 {
			return
		}

		// Ambil gambar thumbnail
		gambarURL := ""
		if img := sel.Find("img").First(); img.Length() > 0 {
			if src, ok := img.Attr("src"); ok {
				gambarURL = src
			} else if src, ok := img.Attr("data-src"); ok {
				gambarURL = src
			}
		}

		// Cari tanggal di sekitar link
		tanggal := ""
		teksLengkap := sel.Text()
		// Format tanggal di cryptowave: "February 11, 2026 | 04:11 WIB"
		if idx := strings.Index(teksLengkap, "202"); idx > 0 {
			// Coba ekstrak tanggal dari teks
			start := idx - 15
			if start < 0 {
				start = 0
			}
			end := idx + 20
			if end > len(teksLengkap) {
				end = len(teksLengkap)
			}
			potongan := teksLengkap[start:end]
			tanggal = strings.TrimSpace(potongan)
		}

		sumberURL := href
		if !strings.HasPrefix(sumberURL, "http") {
			sumberURL = baseURL + href
		}

		items = append(items, BeritaItem{
			Judul:       judul,
			Slug:        slug,
			Ringkasan:   "",
			GambarURL:   gambarURL,
			SumberURL:   sumberURL,
			TanggalAsli: tanggal,
		})
	})

	// Ambil detail (ringkasan) untuk setiap berita
	for i := range items {
		if i >= maxBerita {
			break
		}
		detail, err := s.scrapeDetailArtikel(items[i].SumberURL)
		if err != nil {
			log.Printf("[berita] gagal ambil detail %s: %v", items[i].Slug, err)
			continue
		}
		items[i].Ringkasan = detail.Ringkasan
		items[i].Penulis = detail.Penulis
		items[i].Kategori = detail.Kategori
		if detail.GambarURL != "" && items[i].GambarURL == "" {
			items[i].GambarURL = detail.GambarURL
		}
		if detail.TanggalAsli != "" && items[i].TanggalAsli == "" {
			items[i].TanggalAsli = detail.TanggalAsli
		}

		// Jeda antar request detail
		time.Sleep(300 * time.Millisecond)
	}

	return items, nil
}

// detailArtikel — data parsial dari halaman detail
type detailArtikel struct {
	Ringkasan   string
	Penulis     string
	Kategori    string
	GambarURL   string
	TanggalAsli string
}

// scrapeDetailArtikel — ambil ringkasan, penulis, dan gambar dari halaman detail
func (s *Scraper) scrapeDetailArtikel(url string) (detailArtikel, error) {
	doc, err := s.fetchDocument(url)
	if err != nil {
		return detailArtikel{}, err
	}

	var detail detailArtikel

	// Ambil meta description sebagai ringkasan
	if meta, exists := doc.Find(`meta[name="description"]`).Attr("content"); exists {
		detail.Ringkasan = strings.TrimSpace(meta)
	}
	if detail.Ringkasan == "" {
		if meta, exists := doc.Find(`meta[property="og:description"]`).Attr("content"); exists {
			detail.Ringkasan = strings.TrimSpace(meta)
		}
	}

	// Fallback: ambil paragraf pertama dari konten artikel
	if detail.Ringkasan == "" {
		doc.Find("article p, .article-content p, .content p, main p").EachWithBreak(func(i int, sel *goquery.Selection) bool {
			text := strings.TrimSpace(sel.Text())
			if len(text) > 50 {
				detail.Ringkasan = text
				if len(detail.Ringkasan) > 200 {
					detail.Ringkasan = detail.Ringkasan[:200] + "..."
				}
				return false
			}
			return true
		})
	}

	// Ambil penulis
	doc.Find("a[href*='/author/']").EachWithBreak(func(i int, sel *goquery.Selection) bool {
		penulis := strings.TrimSpace(sel.Text())
		if penulis != "" {
			detail.Penulis = penulis
			return false
		}
		return true
	})

	// Ambil gambar OG
	if ogImg, exists := doc.Find(`meta[property="og:image"]`).Attr("content"); exists {
		detail.GambarURL = ogImg
	}

	// Ambil kategori dari breadcrumb atau tag
	doc.Find("a[href*='/category/']").EachWithBreak(func(i int, sel *goquery.Selection) bool {
		cat := strings.TrimSpace(sel.Text())
		if cat != "" && cat != "All" {
			detail.Kategori = cat
			return false
		}
		return true
	})

	return detail, nil
}

// fetchDocument — fetch dan parse HTML dari URL
func (s *Scraper) fetchDocument(url string) (*goquery.Document, error) {
	client := &http.Client{
		Timeout: 15 * time.Second,
	}

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, fmt.Errorf("gagal buat request: %w", err)
	}
	req.Header.Set("User-Agent", userAgent)
	req.Header.Set("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
	req.Header.Set("Accept-Language", "id-ID,id;q=0.9,en-US;q=0.8,en;q=0.7")

	resp, err := client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("gagal fetch %s: %w", url, err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("status %d dari %s", resp.StatusCode, url)
	}

	doc, err := goquery.NewDocumentFromReader(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("gagal parse HTML: %w", err)
	}

	return doc, nil
}

// extractSlug — ambil slug dari URL artikel
func extractSlug(href string) string {
	parts := strings.Split(href, "/articles/")
	if len(parts) < 2 {
		return ""
	}
	slug := strings.TrimRight(parts[1], "/")
	// Hapus query string jika ada
	if idx := strings.Index(slug, "?"); idx > 0 {
		slug = slug[:idx]
	}
	return slug
}

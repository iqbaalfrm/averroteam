package portofolio

import (
    "fmt"
    "os"
)

// DummyPriceProvider membaca harga aset dari ENV, format: PRICE_BTC=450000000
// Ini placeholder sampai integrasi API eksternal dilakukan.
type DummyPriceProvider struct{}

func (p DummyPriceProvider) GetPrice(symbol string) (float64, error) {
    if symbol == "" {
        return 0, nil
    }

    key := "PRICE_" + symbol
    raw := os.Getenv(key)
    if raw == "" {
        return 0, nil
    }

    value, err := parseFloat(raw)
    if err != nil {
        return 0, nil
    }

    return value, nil
}

func parseFloat(raw string) (float64, error) {
    var value float64
    _, err := fmt.Sscanf(raw, "%f", &value)
    return value, err
}
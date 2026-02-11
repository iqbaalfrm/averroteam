package config

import (
	"os"
	"strconv"
)

type Config struct {
	AppPort                string
	DBPath                 string
	JWTSecret              string
	TokenTTL               string
	AdminEmail             string
	AdminPassword          string
	GoldPrice              float64
	CoinGeckoBaseURL       string
	CoinGeckoIDs           string
	CoinGeckoPriorityIDs   string
	CoinGeckoCachePath     string
	CoinGeckoCacheTTLHours int
	ScreenerCSVPath        string
}

func Load() Config {
	return Config{
		AppPort:                getEnv("APP_PORT", "8080"),
		DBPath:                 getEnv("DB_PATH", "averroes.db"),
		JWTSecret:              getEnv("JWT_SECRET", "averroes-secret"),
		TokenTTL:               getEnv("TOKEN_TTL_HOURS", "24"),
		AdminEmail:             getEnv("ADMIN_EMAIL", "admin@averroes.local"),
		AdminPassword:          getEnv("ADMIN_PASSWORD", "admin123"),
		GoldPrice:              getEnvFloat("GOLD_PRICE", 0),
		CoinGeckoBaseURL:       getEnv("COINGECKO_BASE_URL", "https://api.coingecko.com/api/v3"),
		CoinGeckoIDs:           getEnv("COINGECKO_IDS", ""),
		CoinGeckoPriorityIDs:   getEnv("COINGECKO_PRIORITY_IDS", ""),
		CoinGeckoCachePath:     getEnv("COINGECKO_CACHE_PATH", "docs/coingecko_coins_cache.json"),
		CoinGeckoCacheTTLHours: getEnvInt("COINGECKO_CACHE_TTL_HOURS", 168),
		ScreenerCSVPath:        getEnv("SCREENER_CSV_PATH", "docs/CSV_Averroes.csv"),
	}
}

func getEnv(key, fallback string) string {
	value := os.Getenv(key)
	if value == "" {
		return fallback
	}
	return value
}

func getEnvFloat(key string, fallback float64) float64 {
	value := os.Getenv(key)
	if value == "" {
		return fallback
	}
	parsed, err := strconv.ParseFloat(value, 64)
	if err != nil {
		return fallback
	}
	return parsed
}

func getEnvInt(key string, fallback int) int {
	value := os.Getenv(key)
	if value == "" {
		return fallback
	}
	parsed, err := strconv.Atoi(value)
	if err != nil {
		return fallback
	}
	return parsed
}

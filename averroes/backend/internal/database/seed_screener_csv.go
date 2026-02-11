package database

import (
	"encoding/csv"
	"errors"
	"fmt"
	"io"
	"os"
	"regexp"
	"strings"

	"gorm.io/gorm"
)

var symbolPattern = regexp.MustCompile(`\(([A-Za-z0-9._-]+)\)`)

// SeedScreenerFromCSV melakukan upsert data screener dari file CSV.
// Return: inserted, updated, skipped, error.
func SeedScreenerFromCSV(db *gorm.DB, csvPath string) (int, int, int, error) {
	file, err := os.Open(csvPath)
	if err != nil {
		return 0, 0, 0, err
	}
	defer file.Close()

	reader := csv.NewReader(file)
	reader.Comma = ';'
	reader.FieldsPerRecord = -1
	reader.LazyQuotes = true

	header, err := reader.Read()
	if err != nil {
		return 0, 0, 0, err
	}
	if len(header) < 6 {
		return 0, 0, 0, errors.New("format CSV tidak valid")
	}

	inserted := 0
	updated := 0
	skipped := 0

	err = db.Transaction(func(tx *gorm.DB) error {
		for {
			record, readErr := reader.Read()
			if readErr == io.EOF {
				break
			}
			if readErr != nil {
				return readErr
			}

			if len(record) < 6 {
				skipped++
				continue
			}

			assetRaw := strings.TrimSpace(record[1])
			underlying := strings.TrimSpace(record[2])
			valueNote := strings.TrimSpace(record[3])
			deliverable := strings.TrimSpace(record[4])
			rawSharia := strings.TrimSpace(record[5])

			if assetRaw == "" {
				skipped++
				continue
			}

			name, symbol := extractNameAndSymbol(assetRaw)
			if symbol == "" {
				symbol = inferSymbol(name)
			}
			if name == "" || symbol == "" {
				skipped++
				continue
			}

			status := normalizeShariaStatus(rawSharia)
			penjelasanFiqh := buildPenjelasanFiqh(underlying, valueNote, deliverable)
			referensi := fmt.Sprintf(
				"Sumber CSV Averroes (kolom Yes/No Sharia: %s)",
				fallbackIfEmpty(rawSharia, "-"),
			)

			var existing ScreenerKoin
			err := tx.Where("LOWER(nama_koin) = LOWER(?) AND UPPER(simbol) = UPPER(?)", name, symbol).First(&existing).Error
			if err != nil && err != gorm.ErrRecordNotFound {
				return err
			}

			if err == gorm.ErrRecordNotFound {
				newItem := ScreenerKoin{
					NamaKoin:       name,
					Simbol:         strings.ToUpper(symbol),
					StatusSyariah:  status,
					PenjelasanFiqh: penjelasanFiqh,
					ReferensiUlama: referensi,
				}
				if errCreate := tx.Create(&newItem).Error; errCreate != nil {
					return errCreate
				}
				inserted++
				continue
			}

			existing.StatusSyariah = status
			existing.PenjelasanFiqh = penjelasanFiqh
			existing.ReferensiUlama = referensi
			existing.NamaKoin = name
			existing.Simbol = strings.ToUpper(symbol)

			if errSave := tx.Save(&existing).Error; errSave != nil {
				return errSave
			}
			updated++
		}

		return nil
	})
	if err != nil {
		return 0, 0, 0, err
	}

	return inserted, updated, skipped, nil
}

func extractNameAndSymbol(asset string) (string, string) {
	name := strings.TrimSpace(asset)
	matches := symbolPattern.FindStringSubmatch(asset)
	if len(matches) > 1 {
		symbol := strings.TrimSpace(matches[1])
		name = strings.TrimSpace(symbolPattern.ReplaceAllString(asset, ""))
		name = strings.TrimSpace(strings.TrimSuffix(name, "-"))
		return name, symbol
	}
	return name, ""
}

func inferSymbol(name string) string {
	if name == "" {
		return ""
	}

	only := strings.Map(func(r rune) rune {
		if (r >= 'A' && r <= 'Z') || (r >= 'a' && r <= 'z') || (r >= '0' && r <= '9') {
			return r
		}
		return -1
	}, name)

	if only == "" {
		return ""
	}
	return strings.ToUpper(only)
}

func normalizeShariaStatus(raw string) string {
	lower := strings.ToLower(strings.TrimSpace(raw))
	if strings.HasPrefix(lower, "yes") {
		return "halal"
	}
	if strings.HasPrefix(lower, "no") {
		return "haram"
	}
	if strings.HasPrefix(lower, "grey") || lower == "?" || lower == "" {
		return "proses"
	}
	return "proses"
}

func buildPenjelasanFiqh(underlying string, value string, deliverable string) string {
	parts := make([]string, 0, 3)
	if underlying != "" {
		parts = append(parts, "Underlying: "+underlying)
	}
	if value != "" {
		parts = append(parts, "Nilai yang jelas: "+value)
	}
	if deliverable != "" {
		parts = append(parts, "Serah-terima: "+deliverable)
	}
	return strings.Join(parts, ". ")
}

func fallbackIfEmpty(value string, fallback string) string {
	trimmed := strings.TrimSpace(value)
	if trimmed == "" {
		return fallback
	}
	return trimmed
}

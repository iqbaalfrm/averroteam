package database

import (
    "fmt"

    "gorm.io/driver/sqlite"
    "gorm.io/gorm"
)

func ConnectSQLite(dbPath string) (*gorm.DB, error) {
    if dbPath == "" {
        dbPath = "averroes.db"
    }

    db, err := gorm.Open(sqlite.Open(dbPath), &gorm.Config{})
    if err != nil {
        return nil, fmt.Errorf("gagal koneksi database: %w", err)
    }

    return db, nil
}
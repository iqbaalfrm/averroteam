package zakat

import (
    "errors"

    "gorm.io/gorm"

    "averroes/internal/database"
    "averroes/internal/modules/portofolio"
)

type Service struct {
    db *gorm.DB
    prices portofolio.PriceProvider
}

func NewService(db *gorm.DB, prices portofolio.PriceProvider) *Service {
    return &Service{db: db, prices: prices}
}

func (s *Service) Estimasi(userID uint, hargaEmas float64) (EstimasiResponse, error) {
    if hargaEmas <= 0 {
        return EstimasiResponse{}, errors.New("harga emas wajib diisi")
    }

    var items []database.Portofolio
    if err := s.db.Where("user_id = ?", userID).Find(&items).Error; err != nil {
        return EstimasiResponse{}, err
    }

    total := 0.0
    for _, item := range items {
        harga := 0.0
        if s.prices != nil {
            if p, err := s.prices.GetPrice(item.Simbol); err == nil {
                harga = p
            }
        }
        total += item.Jumlah * harga
    }

    nishab := hargaEmas * 85
    wajib := total >= nishab
    zakat := 0.0
    if wajib {
        zakat = total * 0.025
    }

    return EstimasiResponse{
        TotalAset: total,
        HargaEmas: hargaEmas,
        Nishab:    nishab,
        Zakat:     zakat,
        Wajib:     wajib,
    }, nil
}
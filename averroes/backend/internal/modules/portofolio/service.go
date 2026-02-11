package portofolio

import (
    "errors"
    "strings"

    "gorm.io/gorm"

    "averroes/internal/database"
)

type Service struct {
    db *gorm.DB
    prices PriceProvider
}

type PriceProvider interface {
    GetPrice(symbol string) (float64, error)
}

type CoinListRefresher interface {
    ForceRefreshCoinList() error
}

func NewService(db *gorm.DB, prices PriceProvider) *Service {
    return &Service{db: db, prices: prices}
}

func (s *Service) List(userID uint) ([]ItemResponse, error) {
    var items []database.Portofolio
    if err := s.db.Where("user_id = ?", userID).Order("id desc").Find(&items).Error; err != nil {
        return nil, err
    }

    result := make([]ItemResponse, 0, len(items))
    for _, item := range items {
        harga := 0.0
        if s.prices != nil {
            if p, err := s.prices.GetPrice(item.Simbol); err == nil {
                harga = p
            }
        }
        nilai := item.Jumlah * harga

        result = append(result, ItemResponse{
            ID:       item.ID,
            NamaAset: item.NamaAset,
            Simbol:   item.Simbol,
            Jumlah:   item.Jumlah,
            Harga:    harga,
            Nilai:    nilai,
        })
    }

    return result, nil
}

func (s *Service) Create(userID uint, input CreateRequest) (database.Portofolio, error) {
    if err := validateInput(input.NamaAset, input.Simbol, input.Jumlah); err != nil {
        return database.Portofolio{}, err
    }

    item := database.Portofolio{
        UserID:   userID,
        NamaAset: strings.TrimSpace(input.NamaAset),
        Simbol:   strings.ToUpper(strings.TrimSpace(input.Simbol)),
        Jumlah:   input.Jumlah,
    }

    if err := s.db.Create(&item).Error; err != nil {
        return database.Portofolio{}, err
    }

    return item, nil
}

func (s *Service) Update(userID uint, id uint, input UpdateRequest) (database.Portofolio, error) {
    if err := validateInput(input.NamaAset, input.Simbol, input.Jumlah); err != nil {
        return database.Portofolio{}, err
    }

    var item database.Portofolio
    if err := s.db.Where("user_id = ?", userID).First(&item, id).Error; err != nil {
        return database.Portofolio{}, err
    }

    item.NamaAset = strings.TrimSpace(input.NamaAset)
    item.Simbol = strings.ToUpper(strings.TrimSpace(input.Simbol))
    item.Jumlah = input.Jumlah

    if err := s.db.Save(&item).Error; err != nil {
        return database.Portofolio{}, err
    }

    return item, nil
}

func (s *Service) Delete(userID uint, id uint) error {
    return s.db.Where("user_id = ?", userID).Delete(&database.Portofolio{}, id).Error
}

func (s *Service) RefreshCoinList() error {
    refresher, ok := s.prices.(CoinListRefresher)
    if !ok || refresher == nil {
        return errors.New("refresh tidak didukung")
    }
    return refresher.ForceRefreshCoinList()
}

func validateInput(nama string, simbol string, jumlah float64) error {
    if strings.TrimSpace(nama) == "" {
        return errors.New("nama aset wajib diisi")
    }
    if strings.TrimSpace(simbol) == "" {
        return errors.New("simbol wajib diisi")
    }
    if jumlah <= 0 {
        return errors.New("jumlah wajib lebih dari 0")
    }
    return nil
}

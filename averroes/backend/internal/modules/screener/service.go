package screener

import (
    "errors"
    "strings"

    "gorm.io/gorm"

    "averroes/internal/database"
)

type Service struct {
    db *gorm.DB
}

func NewService(db *gorm.DB) *Service {
    return &Service{db: db}
}

func (s *Service) List(status string, q string) ([]database.ScreenerKoin, error) {
    var items []database.ScreenerKoin

    tx := s.db.Model(&database.ScreenerKoin{})
    if status != "" {
        tx = tx.Where("status_syariah = ?", status)
    }
    if q != "" {
        like := "%" + q + "%"
        tx = tx.Where("nama_koin LIKE ? OR simbol LIKE ?", like, like)
    }

    if err := tx.Order("id desc").Find(&items).Error; err != nil {
        return nil, err
    }

    return items, nil
}

func (s *Service) GetByID(id uint) (database.ScreenerKoin, error) {
    var item database.ScreenerKoin
    if err := s.db.First(&item, id).Error; err != nil {
        return database.ScreenerKoin{}, err
    }
    return item, nil
}

func (s *Service) Create(input CreateRequest) (database.ScreenerKoin, error) {
    if err := validateInput(input); err != nil {
        return database.ScreenerKoin{}, err
    }

    item := database.ScreenerKoin{
        NamaKoin:       input.NamaKoin,
        Simbol:         strings.ToUpper(strings.TrimSpace(input.Simbol)),
        StatusSyariah:  input.StatusSyariah,
        PenjelasanFiqh: input.PenjelasanFiqh,
        ReferensiUlama: input.ReferensiUlama,
    }

    if err := s.db.Create(&item).Error; err != nil {
        return database.ScreenerKoin{}, err
    }

    return item, nil
}

func (s *Service) Update(id uint, input UpdateRequest) (database.ScreenerKoin, error) {
    if err := validateInput(CreateRequest{
        NamaKoin:       input.NamaKoin,
        Simbol:         input.Simbol,
        StatusSyariah:  input.StatusSyariah,
        PenjelasanFiqh: input.PenjelasanFiqh,
        ReferensiUlama: input.ReferensiUlama,
    }); err != nil {
        return database.ScreenerKoin{}, err
    }

    item, err := s.GetByID(id)
    if err != nil {
        return database.ScreenerKoin{}, err
    }

    item.NamaKoin = input.NamaKoin
    item.Simbol = strings.ToUpper(strings.TrimSpace(input.Simbol))
    item.StatusSyariah = input.StatusSyariah
    item.PenjelasanFiqh = input.PenjelasanFiqh
    item.ReferensiUlama = input.ReferensiUlama

    if err := s.db.Save(&item).Error; err != nil {
        return database.ScreenerKoin{}, err
    }

    return item, nil
}

func (s *Service) Delete(id uint) error {
    if err := s.db.Delete(&database.ScreenerKoin{}, id).Error; err != nil {
        return err
    }
    return nil
}

func validateInput(input CreateRequest) error {
    if strings.TrimSpace(input.NamaKoin) == "" {
        return errors.New("nama koin wajib diisi")
    }
    if strings.TrimSpace(input.Simbol) == "" {
        return errors.New("simbol wajib diisi")
    }
    if strings.TrimSpace(input.StatusSyariah) == "" {
        return errors.New("status syariah wajib diisi")
    }
    return nil
}
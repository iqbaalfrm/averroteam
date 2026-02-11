package progres

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

func (s *Service) List(userID uint, kelasID uint) ([]database.ProgresKelas, error) {
    var items []database.ProgresKelas
    tx := s.db.Model(&database.ProgresKelas{}).Where("user_id = ?", userID)
    if kelasID > 0 {
        tx = tx.Where("kelas_id = ?", kelasID)
    }

    if err := tx.Order("id desc").Find(&items).Error; err != nil {
        return nil, err
    }
    return items, nil
}

func (s *Service) Upsert(userID uint, input UpsertRequest) (database.ProgresKelas, error) {
    if err := validateInput(input); err != nil {
        return database.ProgresKelas{}, err
    }

    var item database.ProgresKelas
    err := s.db.Where("user_id = ? AND kelas_id = ?", userID, input.KelasID).First(&item).Error
    if err != nil {
        if errors.Is(err, gorm.ErrRecordNotFound) {
            item = database.ProgresKelas{
                UserID:        userID,
                KelasID:       input.KelasID,
                MateriTerakhir: input.MateriTerakhir,
                StatusKuis:    strings.TrimSpace(input.StatusKuis),
            }
            if err := s.db.Create(&item).Error; err != nil {
                return database.ProgresKelas{}, err
            }
            return item, nil
        }
        return database.ProgresKelas{}, err
    }

    item.MateriTerakhir = input.MateriTerakhir
    item.StatusKuis = strings.TrimSpace(input.StatusKuis)

    if err := s.db.Save(&item).Error; err != nil {
        return database.ProgresKelas{}, err
    }

    return item, nil
}

func validateInput(input UpsertRequest) error {
    if input.KelasID == 0 {
        return errors.New("kelas_id wajib diisi")
    }
    return nil
}
package screener

type CreateRequest struct {
    NamaKoin       string `json:"nama_koin"`
    Simbol         string `json:"simbol"`
    StatusSyariah  string `json:"status_syariah"`
    PenjelasanFiqh string `json:"penjelasan_fiqh"`
    ReferensiUlama string `json:"referensi_ulama"`
}

type UpdateRequest struct {
    NamaKoin       string `json:"nama_koin"`
    Simbol         string `json:"simbol"`
    StatusSyariah  string `json:"status_syariah"`
    PenjelasanFiqh string `json:"penjelasan_fiqh"`
    ReferensiUlama string `json:"referensi_ulama"`
}
package zakat

type EstimasiResponse struct {
    TotalAset float64 `json:"total_aset"`
    HargaEmas float64 `json:"harga_emas"`
    Nishab    float64 `json:"nishab"`
    Zakat     float64 `json:"zakat"`
    Wajib     bool    `json:"wajib"`
}
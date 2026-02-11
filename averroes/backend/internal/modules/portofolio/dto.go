package portofolio

type CreateRequest struct {
    NamaAset string  `json:"nama_aset"`
    Simbol   string  `json:"simbol"`
    Jumlah   float64 `json:"jumlah"`
}

type UpdateRequest struct {
    NamaAset string  `json:"nama_aset"`
    Simbol   string  `json:"simbol"`
    Jumlah   float64 `json:"jumlah"`
}

type ItemResponse struct {
    ID       uint    `json:"id"`
    NamaAset string  `json:"nama_aset"`
    Simbol   string  `json:"simbol"`
    Jumlah   float64 `json:"jumlah"`
    Harga    float64 `json:"harga"`
    Nilai    float64 `json:"nilai"`
}
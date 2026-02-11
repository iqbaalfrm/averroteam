package materi

type CreateRequest struct {
    KelasID  uint   `json:"kelas_id"`
    Judul    string `json:"judul"`
    Konten   string `json:"konten"`
    Urutan   int    `json:"urutan"`
}

type UpdateRequest struct {
    KelasID  uint   `json:"kelas_id"`
    Judul    string `json:"judul"`
    Konten   string `json:"konten"`
    Urutan   int    `json:"urutan"`
}
package kuis

type CreateRequest struct {
    KelasID    uint   `json:"kelas_id"`
    Pertanyaan string `json:"pertanyaan"`
}

type UpdateRequest struct {
    KelasID    uint   `json:"kelas_id"`
    Pertanyaan string `json:"pertanyaan"`
}
package kelas

type CreateRequest struct {
    Judul     string `json:"judul"`
    Deskripsi string `json:"deskripsi"`
}

type UpdateRequest struct {
    Judul     string `json:"judul"`
    Deskripsi string `json:"deskripsi"`
}
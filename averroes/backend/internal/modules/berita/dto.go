package berita

// BeritaItem — representasi satu berita hasil scraping
type BeritaItem struct {
	Judul       string `json:"judul"`
	Slug        string `json:"slug"`
	Ringkasan   string `json:"ringkasan"`
	Penulis     string `json:"penulis"`
	Kategori    string `json:"kategori"`
	GambarURL   string `json:"gambar_url"`
	SumberURL   string `json:"sumber_url"`
	TanggalAsli string `json:"tanggal_asli"`
}

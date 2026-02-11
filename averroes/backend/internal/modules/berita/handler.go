package berita

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"

	"averroes/internal/utils"
)

// Handler — handler HTTP untuk endpoint berita
type Handler struct {
	scraper *Scraper
}

// NewHandler — buat handler baru
func NewHandler(scraper *Scraper) *Handler {
	return &Handler{scraper: scraper}
}

// ListBerita — GET /api/berita
// Query params: limit (default 20, max 20)
func (h *Handler) ListBerita(c *gin.Context) {
	items, err := h.scraper.AmbilBerita()
	if err != nil {
		utils.JSONError(c, http.StatusInternalServerError, "Gagal mengambil berita terbaru")
		return
	}

	// Terapkan limit jika diminta
	limit := 20
	if l := c.Query("limit"); l != "" {
		if parsed, err := strconv.Atoi(l); err == nil && parsed > 0 && parsed <= 20 {
			limit = parsed
		}
	}

	if len(items) > limit {
		items = items[:limit]
	}

	utils.JSONSuccess(c, "Berhasil", gin.H{
		"total":  len(items),
		"sumber": "cryptowave.co.id",
		"berita": items,
	})
}

// RefreshBerita — POST /api/admin/berita/refresh
// Paksa scrape ulang (bypass cache)
func (h *Handler) RefreshBerita(c *gin.Context) {
	// Reset cache agar scrape ulang
	h.scraper.mu.Lock()
	h.scraper.cache = nil
	h.scraper.mu.Unlock()

	items, err := h.scraper.AmbilBerita()
	if err != nil {
		utils.JSONError(c, http.StatusInternalServerError, "Gagal refresh berita: "+err.Error())
		return
	}

	utils.JSONSuccess(c, "Berhasil refresh berita", gin.H{
		"total":  len(items),
		"sumber": "cryptowave.co.id",
		"berita": items,
	})
}

package zakat

import (
    "net/http"

    "github.com/gin-gonic/gin"

    "averroes/internal/utils"
)

type Handler struct {
    service *Service
    goldPrice float64
}

func NewHandler(service *Service, goldPrice float64) *Handler {
    return &Handler{service: service, goldPrice: goldPrice}
}

func (h *Handler) Estimasi(c *gin.Context) {
    userID, ok := getUserID(c)
    if !ok {
        utils.JSONError(c, http.StatusUnauthorized, "Akses tidak valid")
        return
    }

    hargaEmas := h.goldPrice
    if hargaEmas == 0 {
        utils.JSONError(c, http.StatusBadRequest, "Harga emas belum tersedia")
        return
    }

    result, err := h.service.Estimasi(userID, hargaEmas)
    if err != nil {
        utils.JSONError(c, http.StatusBadRequest, err.Error())
        return
    }

    utils.JSONSuccess(c, "Berhasil", result)
}

func getUserID(c *gin.Context) (uint, bool) {
    value, ok := c.Get("user_id")
    if !ok {
        return 0, false
    }
    id, ok := value.(uint)
    if !ok || id == 0 {
        return 0, false
    }
    return id, true
}
package progres

import (
    "net/http"
    "strconv"

    "github.com/gin-gonic/gin"

    "averroes/internal/utils"
)

type Handler struct {
    service *Service
}

func NewHandler(service *Service) *Handler {
    return &Handler{service: service}
}

func (h *Handler) List(c *gin.Context) {
    userID, ok := getUserID(c)
    if !ok {
        utils.JSONError(c, http.StatusUnauthorized, "Akses tidak valid")
        return
    }

    kelasID, _ := parseUintQuery(c.Query("kelas_id"))

    items, err := h.service.List(userID, kelasID)
    if err != nil {
        utils.JSONError(c, http.StatusInternalServerError, "Gagal memuat data")
        return
    }

    utils.JSONSuccess(c, "Berhasil", items)
}

func (h *Handler) Upsert(c *gin.Context) {
    userID, ok := getUserID(c)
    if !ok {
        utils.JSONError(c, http.StatusUnauthorized, "Akses tidak valid")
        return
    }

    var req UpsertRequest
    if err := c.ShouldBindJSON(&req); err != nil {
        utils.JSONError(c, http.StatusBadRequest, "Format data tidak valid")
        return
    }

    item, err := h.service.Upsert(userID, req)
    if err != nil {
        utils.JSONError(c, http.StatusBadRequest, err.Error())
        return
    }

    utils.JSONSuccess(c, "Berhasil", item)
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

func parseUintQuery(raw string) (uint, error) {
    if raw == "" {
        return 0, nil
    }
    value, err := strconv.ParseUint(raw, 10, 64)
    if err != nil {
        return 0, err
    }
    return uint(value), nil
}
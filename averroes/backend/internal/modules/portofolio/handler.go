package portofolio

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

    items, err := h.service.List(userID)
    if err != nil {
        utils.JSONError(c, http.StatusInternalServerError, "Gagal memuat data")
        return
    }

    utils.JSONSuccess(c, "Berhasil", items)
}

func (h *Handler) Create(c *gin.Context) {
    userID, ok := getUserID(c)
    if !ok {
        utils.JSONError(c, http.StatusUnauthorized, "Akses tidak valid")
        return
    }

    var req CreateRequest
    if err := c.ShouldBindJSON(&req); err != nil {
        utils.JSONError(c, http.StatusBadRequest, "Format data tidak valid")
        return
    }

    item, err := h.service.Create(userID, req)
    if err != nil {
        utils.JSONError(c, http.StatusBadRequest, err.Error())
        return
    }

    utils.JSONSuccess(c, "Berhasil", item)
}

func (h *Handler) Update(c *gin.Context) {
    userID, ok := getUserID(c)
    if !ok {
        utils.JSONError(c, http.StatusUnauthorized, "Akses tidak valid")
        return
    }

    id, err := parseIDParam(c.Param("id"))
    if err != nil {
        utils.JSONError(c, http.StatusBadRequest, "ID tidak valid")
        return
    }

    var req UpdateRequest
    if err := c.ShouldBindJSON(&req); err != nil {
        utils.JSONError(c, http.StatusBadRequest, "Format data tidak valid")
        return
    }

    item, err := h.service.Update(userID, id, req)
    if err != nil {
        if err.Error() == "record not found" {
            utils.JSONError(c, http.StatusNotFound, "Data tidak ditemukan")
            return
        }
        utils.JSONError(c, http.StatusBadRequest, err.Error())
        return
    }

    utils.JSONSuccess(c, "Berhasil", item)
}

func (h *Handler) Delete(c *gin.Context) {
    userID, ok := getUserID(c)
    if !ok {
        utils.JSONError(c, http.StatusUnauthorized, "Akses tidak valid")
        return
    }

    id, err := parseIDParam(c.Param("id"))
    if err != nil {
        utils.JSONError(c, http.StatusBadRequest, "ID tidak valid")
        return
    }

    if err := h.service.Delete(userID, id); err != nil {
        utils.JSONError(c, http.StatusInternalServerError, "Gagal menghapus data")
        return
    }

    utils.JSONSuccess(c, "Berhasil", gin.H{"deleted": id})
}

func (h *Handler) RefreshCoinList(c *gin.Context) {
    if err := h.service.RefreshCoinList(); err != nil {
        utils.JSONError(c, http.StatusBadRequest, err.Error())
        return
    }

    utils.JSONSuccess(c, "Berhasil", gin.H{"status": "refreshed"})
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

func parseIDParam(raw string) (uint, error) {
    value, err := strconv.ParseUint(raw, 10, 64)
    if err != nil || value == 0 {
        return 0, err
    }
    return uint(value), nil
}

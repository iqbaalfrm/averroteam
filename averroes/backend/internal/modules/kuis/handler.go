package kuis

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

func (h *Handler) ListPublic(c *gin.Context) {
    kelasID, _ := parseUintQuery(c.Query("kelas_id"))

    items, err := h.service.List(kelasID)
    if err != nil {
        utils.JSONError(c, http.StatusInternalServerError, "Gagal memuat data")
        return
    }

    utils.JSONSuccess(c, "Berhasil", items)
}

func (h *Handler) DetailPublic(c *gin.Context) {
    id, err := parseIDParam(c.Param("id"))
    if err != nil {
        utils.JSONError(c, http.StatusBadRequest, "ID tidak valid")
        return
    }

    item, err := h.service.GetByID(id)
    if err != nil {
        utils.JSONError(c, http.StatusNotFound, "Data tidak ditemukan")
        return
    }

    utils.JSONSuccess(c, "Berhasil", item)
}

func (h *Handler) ListAdmin(c *gin.Context) { h.ListPublic(c) }

func (h *Handler) CreateAdmin(c *gin.Context) {
    var req CreateRequest
    if err := c.ShouldBindJSON(&req); err != nil {
        utils.JSONError(c, http.StatusBadRequest, "Format data tidak valid")
        return
    }

    item, err := h.service.Create(req)
    if err != nil {
        utils.JSONError(c, http.StatusBadRequest, err.Error())
        return
    }

    utils.JSONSuccess(c, "Berhasil", item)
}

func (h *Handler) UpdateAdmin(c *gin.Context) {
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

    item, err := h.service.Update(id, req)
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

func (h *Handler) DeleteAdmin(c *gin.Context) {
    id, err := parseIDParam(c.Param("id"))
    if err != nil {
        utils.JSONError(c, http.StatusBadRequest, "ID tidak valid")
        return
    }

    if err := h.service.Delete(id); err != nil {
        utils.JSONError(c, http.StatusInternalServerError, "Gagal menghapus data")
        return
    }

    utils.JSONSuccess(c, "Berhasil", gin.H{"deleted": id})
}

func parseIDParam(raw string) (uint, error) {
    value, err := strconv.ParseUint(raw, 10, 64)
    if err != nil || value == 0 {
        return 0, err
    }
    return uint(value), nil
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
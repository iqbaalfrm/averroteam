package auth

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"averroes/internal/config"
	"averroes/internal/utils"
)

type Handler struct {
	service *Service
	cfg     config.Config
}

type GoogleLoginRequest struct {
	Email string `json:"email"`
}

type AdminLoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type RegisterRequest struct {
	Nama     string `json:"nama"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

type LoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type LupaPasswordRequest struct {
	Email string `json:"email"`
}

type VerifikasiOTPRequest struct {
	Email string `json:"email"`
	Kode  string `json:"kode"`
}

type ResetPasswordRequest struct {
	Email        string `json:"email"`
	Kode         string `json:"kode"`
	PasswordBaru string `json:"password_baru"`
}

func NewHandler(service *Service, cfg config.Config) *Handler {
	return &Handler{service: service, cfg: cfg}
}

func (h *Handler) GoogleLogin(c *gin.Context) {
	var req GoogleLoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.JSONError(c, http.StatusBadRequest, "Format data tidak valid")
		return
	}

	user, err := h.service.FindOrCreateUserByEmail(req.Email)
	if err != nil {
		utils.JSONError(c, http.StatusBadRequest, err.Error())
		return
	}

	token, err := utils.GenerateToken(user, h.cfg.JWTSecret, h.cfg.TokenTTL)
	if err != nil {
		utils.JSONError(c, http.StatusInternalServerError, "Gagal membuat token")
		return
	}

	utils.JSONSuccess(c, "Berhasil", gin.H{
		"token": token,
		"user":  user,
	})
}

func (h *Handler) GuestLogin(c *gin.Context) {
	user, err := h.service.CreateGuestUser()
	if err != nil {
		utils.JSONError(c, http.StatusInternalServerError, "Gagal membuat akun tamu")
		return
	}

	token, err := utils.GenerateToken(user, h.cfg.JWTSecret, h.cfg.TokenTTL)
	if err != nil {
		utils.JSONError(c, http.StatusInternalServerError, "Gagal membuat token")
		return
	}

	utils.JSONSuccess(c, "Berhasil", gin.H{
		"token": token,
		"user":  user,
	})
}

func (h *Handler) Register(c *gin.Context) {
	var req RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.JSONError(c, http.StatusBadRequest, "Format data tidak valid")
		return
	}

	user, err := h.service.RegisterUser(req.Nama, req.Email, req.Password)
	if err != nil {
		utils.JSONError(c, http.StatusBadRequest, err.Error())
		return
	}

	token, err := utils.GenerateToken(user, h.cfg.JWTSecret, h.cfg.TokenTTL)
	if err != nil {
		utils.JSONError(c, http.StatusInternalServerError, "Gagal membuat token")
		return
	}

	utils.JSONSuccess(c, "Berhasil", gin.H{
		"token": token,
		"user":  user,
	})
}

func (h *Handler) EmailLogin(c *gin.Context) {
	var req LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.JSONError(c, http.StatusBadRequest, "Format data tidak valid")
		return
	}

	user, err := h.service.LoginUser(req.Email, req.Password)
	if err != nil {
		utils.JSONError(c, http.StatusUnauthorized, err.Error())
		return
	}

	token, err := utils.GenerateToken(user, h.cfg.JWTSecret, h.cfg.TokenTTL)
	if err != nil {
		utils.JSONError(c, http.StatusInternalServerError, "Gagal membuat token")
		return
	}

	utils.JSONSuccess(c, "Berhasil masuk", gin.H{
		"token": token,
		"user":  user,
	})
}

func (h *Handler) LupaPassword(c *gin.Context) {
	var req LupaPasswordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.JSONError(c, http.StatusBadRequest, "Format data tidak valid")
		return
	}

	kode, err := h.service.GenerateOTP(req.Email, "lupa_password")
	if err != nil {
		utils.JSONError(c, http.StatusBadRequest, err.Error())
		return
	}

	// MODE DEMO: OTP dikembalikan di response.
	// Di production, ganti dengan pengiriman email via SMTP.
	utils.JSONSuccess(c, "Kode OTP telah dikirim ke email Anda", gin.H{
		"email":    req.Email,
		"otp_demo": kode,
	})
}

func (h *Handler) VerifikasiOTP(c *gin.Context) {
	var req VerifikasiOTPRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.JSONError(c, http.StatusBadRequest, "Format data tidak valid")
		return
	}

	if err := h.service.VerifyOTP(req.Email, req.Kode, "lupa_password"); err != nil {
		utils.JSONError(c, http.StatusBadRequest, err.Error())
		return
	}

	utils.JSONSuccess(c, "Kode OTP valid", gin.H{
		"email":         req.Email,
		"terverifikasi": true,
	})
}

func (h *Handler) ResetPassword(c *gin.Context) {
	var req ResetPasswordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.JSONError(c, http.StatusBadRequest, "Format data tidak valid")
		return
	}

	if err := h.service.ResetPassword(req.Email, req.Kode, req.PasswordBaru); err != nil {
		utils.JSONError(c, http.StatusBadRequest, err.Error())
		return
	}

	utils.JSONSuccess(c, "Password berhasil diubah, silakan login kembali", nil)
}

func (h *Handler) AdminLogin(c *gin.Context) {
	var req AdminLoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.JSONError(c, http.StatusBadRequest, "Format data tidak valid")
		return
	}

	if req.Email != h.cfg.AdminEmail || req.Password != h.cfg.AdminPassword {
		utils.JSONError(c, http.StatusUnauthorized, "Email atau password salah")
		return
	}

	user, err := h.service.FindOrCreateAdmin(req.Email)
	if err != nil {
		utils.JSONError(c, http.StatusInternalServerError, "Gagal membuat akun admin")
		return
	}

	token, err := utils.GenerateToken(user, h.cfg.JWTSecret, h.cfg.TokenTTL)
	if err != nil {
		utils.JSONError(c, http.StatusInternalServerError, "Gagal membuat token")
		return
	}

	utils.JSONSuccess(c, "Berhasil", gin.H{
		"token": token,
		"user":  user,
	})
}

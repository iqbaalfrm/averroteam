package middlewares

import (
    "strings"

    "github.com/gin-gonic/gin"

    "averroes/internal/utils"
)

func AuthJWT(secret string) gin.HandlerFunc {
    return func(c *gin.Context) {
        authHeader := c.GetHeader("Authorization")
        if authHeader == "" {
            utils.JSONError(c, 401, "Token tidak ditemukan")
            c.Abort()
            return
        }

        parts := strings.SplitN(authHeader, " ", 2)
        if len(parts) != 2 || strings.ToLower(parts[0]) != "bearer" {
            utils.JSONError(c, 401, "Format token tidak valid")
            c.Abort()
            return
        }

        claims, err := utils.ParseToken(parts[1], secret)
        if err != nil {
            utils.JSONError(c, 401, "Token tidak valid")
            c.Abort()
            return
        }

        c.Set("user_id", claims.UserID)
        c.Set("email", claims.Email)
        c.Set("role", claims.Role)
        c.Next()
    }
}
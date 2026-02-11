package middlewares

import (
    "github.com/gin-gonic/gin"

    "averroes/internal/utils"
)

func AdminOnly() gin.HandlerFunc {
    return func(c *gin.Context) {
        role, ok := c.Get("role")
        if !ok || role != "admin" {
            utils.JSONError(c, 403, "Akses admin diperlukan")
            c.Abort()
            return
        }
        c.Next()
    }
}
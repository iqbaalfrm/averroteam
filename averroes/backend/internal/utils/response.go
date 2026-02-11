package utils

import "github.com/gin-gonic/gin"

type APIResponse struct {
    Status bool        `json:"status"`
    Pesan  string      `json:"pesan"`
    Data   interface{} `json:"data,omitempty"`
}

func JSONSuccess(c *gin.Context, message string, data interface{}) {
    c.JSON(200, APIResponse{
        Status: true,
        Pesan:  message,
        Data:   data,
    })
}

func JSONError(c *gin.Context, code int, message string) {
    c.JSON(code, APIResponse{
        Status: false,
        Pesan:  message,
    })
}
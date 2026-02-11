package utils

import (
    "fmt"
    "strconv"
    "time"

    "github.com/golang-jwt/jwt/v5"

    "averroes/internal/database"
)

type Claims struct {
    UserID uint   `json:"user_id"`
    Email  string `json:"email"`
    Role   string `json:"role"`
    jwt.RegisteredClaims
}

func GenerateToken(user database.User, secret string, ttlHours string) (string, error) {
    hours, err := strconv.Atoi(ttlHours)
    if err != nil || hours <= 0 {
        hours = 24
    }

    email := ""
    if user.Email != nil {
        email = *user.Email
    }

    now := time.Now()
    claims := Claims{
        UserID: user.ID,
        Email:  email,
        Role:   user.Role,
        RegisteredClaims: jwt.RegisteredClaims{
            IssuedAt:  jwt.NewNumericDate(now),
            ExpiresAt: jwt.NewNumericDate(now.Add(time.Duration(hours) * time.Hour)),
        },
    }

    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    signed, err := token.SignedString([]byte(secret))
    if err != nil {
        return "", fmt.Errorf("gagal membuat token: %w", err)
    }

    return signed, nil
}

func ParseToken(tokenString string, secret string) (*Claims, error) {
    token, err := jwt.ParseWithClaims(tokenString, &Claims{}, func(t *jwt.Token) (interface{}, error) {
        if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
            return nil, fmt.Errorf("metode signing tidak valid")
        }
        return []byte(secret), nil
    })
    if err != nil {
        return nil, err
    }

    claims, ok := token.Claims.(*Claims)
    if !ok || !token.Valid {
        return nil, fmt.Errorf("token tidak valid")
    }

    return claims, nil
}
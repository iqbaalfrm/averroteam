package main

import (
	"log"
	"time"

	"github.com/gin-gonic/gin"

	"averroes/internal/config"
	"averroes/internal/database"
	"averroes/internal/middlewares"
	"averroes/internal/modules/auth"
	"averroes/internal/modules/berita"
	"averroes/internal/modules/kelas"
	"averroes/internal/modules/kuis"
	"averroes/internal/modules/materi"
	"averroes/internal/modules/portofolio"
	"averroes/internal/modules/progres"
	"averroes/internal/modules/screener"
	"averroes/internal/modules/zakat"
	"averroes/internal/utils"
)

func main() {
	cfg := config.Load()

	db, err := database.ConnectSQLite(cfg.DBPath)
	if err != nil {
		log.Fatalf("%v", err)
	}

	if err := database.AutoMigrate(db); err != nil {
		log.Fatalf("gagal migrasi: %v", err)
	}
	if err := database.SeedDummyLearning(db); err != nil {
		log.Fatalf("gagal seed data dummy kelas: %v", err)
	}
	inserted, updated, skipped, err := database.SeedScreenerFromCSV(db, cfg.ScreenerCSVPath)
	if err != nil {
		log.Printf("seed screener CSV dilewati: %v", err)
	} else {
		log.Printf("seed screener CSV selesai (inserted=%d updated=%d skipped=%d)", inserted, updated, skipped)
	}

	router := gin.New()
	router.Use(gin.Logger(), gin.Recovery())

	authService := auth.NewService(db)
	authHandler := auth.NewHandler(authService, cfg)

	screenerService := screener.NewService(db)
	screenerHandler := screener.NewHandler(screenerService)

	kelasService := kelas.NewService(db)
	kelasHandler := kelas.NewHandler(kelasService)

	materiService := materi.NewService(db)
	materiHandler := materi.NewHandler(materiService)

	kuisService := kuis.NewService(db)
	kuisHandler := kuis.NewHandler(kuisService)

	progresService := progres.NewService(db)
	progresHandler := progres.NewHandler(progresService)

	cacheTTL := time.Duration(cfg.CoinGeckoCacheTTLHours) * time.Hour
	priceProvider := portofolio.NewCoinGeckoProvider(cfg.CoinGeckoBaseURL, cfg.CoinGeckoIDs, cfg.CoinGeckoPriorityIDs, cfg.CoinGeckoCachePath, cacheTTL)
	portofolioService := portofolio.NewService(db, priceProvider)
	portofolioHandler := portofolio.NewHandler(portofolioService)

	zakatService := zakat.NewService(db, priceProvider)
	zakatHandler := zakat.NewHandler(zakatService, cfg.GoldPrice)

	beritaScraper := berita.NewScraper()
	beritaHandler := berita.NewHandler(beritaScraper)

	router.GET("/health", func(c *gin.Context) {
		utils.JSONSuccess(c, "Berhasil", gin.H{"status": "ok"})
	})

	api := router.Group("/api")
	{
		api.POST("/auth/google", authHandler.GoogleLogin)
		api.POST("/auth/guest", authHandler.GuestLogin)
		api.POST("/auth/register", authHandler.Register)
		api.POST("/auth/login", authHandler.EmailLogin)
		api.POST("/auth/lupa-password", authHandler.LupaPassword)
		api.POST("/auth/verifikasi-otp", authHandler.VerifikasiOTP)
		api.POST("/auth/reset-password", authHandler.ResetPassword)

		api.GET("/berita", beritaHandler.ListBerita)

		api.GET("/screener", screenerHandler.ListPublic)
		api.GET("/screener/:id", screenerHandler.DetailPublic)

		api.GET("/kelas", kelasHandler.ListPublic)
		api.GET("/kelas/:id", kelasHandler.DetailPublic)

		api.GET("/materi", materiHandler.ListPublic)
		api.GET("/materi/:id", materiHandler.DetailPublic)

		api.GET("/kuis", kuisHandler.ListPublic)
		api.GET("/kuis/:id", kuisHandler.DetailPublic)

		user := api.Group("")
		user.Use(middlewares.AuthJWT(cfg.JWTSecret))
		{
			user.GET("/progres", progresHandler.List)
			user.PUT("/progres", progresHandler.Upsert)

			user.GET("/portofolio", portofolioHandler.List)
			user.POST("/portofolio", portofolioHandler.Create)
			user.PUT("/portofolio/:id", portofolioHandler.Update)
			user.DELETE("/portofolio/:id", portofolioHandler.Delete)

			user.GET("/zakat/estimasi", zakatHandler.Estimasi)
		}
	}

	admin := router.Group("/api/admin")
	{
		admin.POST("/login", authHandler.AdminLogin)

		secured := admin.Group("")
		secured.Use(middlewares.AuthJWT(cfg.JWTSecret), middlewares.AdminOnly())
		{
			secured.GET("/screener", screenerHandler.ListAdmin)
			secured.POST("/screener", screenerHandler.CreateAdmin)
			secured.PUT("/screener/:id", screenerHandler.UpdateAdmin)
			secured.DELETE("/screener/:id", screenerHandler.DeleteAdmin)

			secured.GET("/kelas", kelasHandler.ListAdmin)
			secured.POST("/kelas", kelasHandler.CreateAdmin)
			secured.PUT("/kelas/:id", kelasHandler.UpdateAdmin)
			secured.DELETE("/kelas/:id", kelasHandler.DeleteAdmin)

			secured.GET("/materi", materiHandler.ListAdmin)
			secured.POST("/materi", materiHandler.CreateAdmin)
			secured.PUT("/materi/:id", materiHandler.UpdateAdmin)
			secured.DELETE("/materi/:id", materiHandler.DeleteAdmin)

			secured.GET("/kuis", kuisHandler.ListAdmin)
			secured.POST("/kuis", kuisHandler.CreateAdmin)
			secured.PUT("/kuis/:id", kuisHandler.UpdateAdmin)
			secured.DELETE("/kuis/:id", kuisHandler.DeleteAdmin)

			secured.POST("/portofolio/refresh-coins", portofolioHandler.RefreshCoinList)

			secured.POST("/berita/refresh", beritaHandler.RefreshBerita)
		}
	}

	if err := router.Run(":" + cfg.AppPort); err != nil {
		log.Fatalf("gagal menjalankan server: %v", err)
	}
}

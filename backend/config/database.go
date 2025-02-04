// config/database.go
package config

import (
	"log"
	"tourista/backend/models"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

var DB *gorm.DB

// ConnectDatabase establishes a connection to the SQLite database and auto-migrates models.
func ConnectDatabase() {
	var err error
	DB, err = gorm.Open(sqlite.Open("tourista.db"), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	})
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	// Auto-migrate models
	err = DB.AutoMigrate(&models.Place{}, &models.Event{}, &models.User{})
	if err != nil {
		log.Fatal("Failed to auto-migrate database:", err)
	}

	log.Println("Database connection established successfully")
}

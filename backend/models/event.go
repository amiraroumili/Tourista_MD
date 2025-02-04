// models/event.go
package models

import (
    "gorm.io/gorm"
)

// Event represents an event in the app
type Event struct {
    gorm.Model
    Title       string `json:"title" binding:"required"`
    Description string `json:"description" binding:"required"`
    Date        string `json:"date" binding:"required"`
    Wilaya      string `json:"wilaya" binding:"required"`
    Location    string `json:"location" binding:"required"`
    ImageURL    string `json:"imageUrl"`
    Category    string `json:"category" binding:"required"`
}
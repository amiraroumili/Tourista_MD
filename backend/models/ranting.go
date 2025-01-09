package models

import (
    "gorm.io/gorm"
)

type Rating struct {
    gorm.Model
    Score     float64 `json:"score"`
    PlaceID   uint    `json:"place_id"`
    UserEmail string  `json:"user_email"`
}

// TableName sets the table name for the Rating model
func (Rating) TableName() string {
    return "rating"
}
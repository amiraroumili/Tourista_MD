// models/user.go
package models

import "gorm.io/gorm"

type User struct {
    gorm.Model
    Email      string `json:"email" binding:"required,email" gorm:"unique"`
    Password   string `json:"password" binding:"required"`
    FirstName  string `json:"firstName" binding:"required"`
    FamilyName string `json:"familyName" binding:"required"`
    Wilaya     string `json:"wilaya" binding:"required"`
}
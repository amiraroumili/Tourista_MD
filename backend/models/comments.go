package models

import (
    "time"
)

type Comment struct {
    ID        uint      `json:"id" gorm:"primaryKey"`
    Content   string    `json:"content"`
    CreatedAt time.Time `json:"createdAt" gorm:"autoCreateTime"`
    UpdatedAt time.Time `json:"updatedAt" gorm:"autoUpdateTime"`
    DeletedAt *time.Time `json:"deletedAt,omitempty" gorm:"index"`

    PlaceID   uint   `json:"placeId" gorm:"not null;index"`
    UserEmail string `json:"userEmail" gorm:"not null;index"`

    Place Place `json:"place" gorm:"foreignKey:PlaceID;constraint:OnDelete:CASCADE;"`
    User  User  `json:"user" gorm:"foreignKey:UserEmail;references:Email;constraint:OnDelete:CASCADE;"`
}

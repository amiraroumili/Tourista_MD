package models

type Place struct {
    ID                   uint    `json:"id" gorm:"primaryKey"`
    Name                 string  `json:"name"`
    Description          string  `json:"description"`
    Category             string  `json:"category"`
    Location             string  `json:"location"`
    ImageURL             string  `json:"imageUrl"`
    Rating               float64 `json:"rating"`
    Status               string  `json:"status"`
    HistoricalBackground string  `json:"historicalBackground"`
    MapURL               string  `json:"mapUrl"`
    IsFavorite           bool    `json:"isFavorite"`
}

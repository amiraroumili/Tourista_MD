package models

type Place struct {
    ID                   string  `json:"id" firestore:"-"`
    Name                 string  `json:"name" firestore:"name"`
    Description          string  `json:"description" firestore:"description"`
    Category             string  `json:"category" firestore:"category"`
    Location             string  `json:"location" firestore:"location"`
    ImageURL             string  `json:"imageUrl" firestore:"imageUrl"`
    Rating               float64 `json:"rating" firestore:"rating"`
    Status               string  `json:"status" firestore:"status"`
    HistoricalBackground string  `json:"historicalBackground" firestore:"historicalBackground"`
    MapURL               string  `json:"mapUrl" firestore:"mapUrl"`
    IsFavorite           bool    `json:"isFavorite" firestore:"isFavorite"`
    CreatedAt            int64   `json:"created_at"`
}
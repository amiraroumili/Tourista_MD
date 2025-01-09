package models

type Event struct {
    ID          string `json:"id" firestore:"-"`
    Title       string `json:"title" firestore:"title"`
    Description string `json:"description" firestore:"description"`
    Date        string `json:"date" firestore:"date"`
    Wilaya      string `json:"wilaya" firestore:"wilaya"`
    Location    string `json:"location" firestore:"location"`
    ImageURL    string `json:"imageUrl" firestore:"imageUrl"`
    Category    string `json:"category" firestore:"category"`
    CreatedAt   int64  `json:"createdAt" firestore:"createdAt"`
}
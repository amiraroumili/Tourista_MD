package models

// Favorite represents a user's favorite place
type Favorite struct {
    ID        string `json:"id" firestore:"id"`
    UserEmail string `json:"user_email" firestore:"user_email"`
    PlaceID   uint   `json:"place_id" firestore:"place_id"`
    CreatedAt int64  `json:"created_at" firestore:"created_at"`
}
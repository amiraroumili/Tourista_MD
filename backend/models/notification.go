package models

type Notification struct {
    ID       string `json:"id" firestore:"id"`
    Title    string `json:"title" firestore:"title"`
    Location string `json:"location" firestore:"location"`
    Date     string `json:"date" firestore:"date"`
    Time     string `json:"time" firestore:"time"`
    CreatedAt int64  `json:"created_at" firestore:"created_at"`
}
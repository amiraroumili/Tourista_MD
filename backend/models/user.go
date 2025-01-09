package models

type User struct {
    ID           string `json:"id" firestore:"-"`
    Email        string `json:"email" firestore:"email"`
    Password     string `json:"password" firestore:"password"`
    FirstName    string `json:"firstName" firestore:"firstName"`
    FamilyName   string `json:"familyName" firestore:"familyName"`
    Wilaya       string `json:"wilaya" firestore:"wilaya"`
    ProfileImage string `json:"profileImage" firestore:"profileImage"`
}
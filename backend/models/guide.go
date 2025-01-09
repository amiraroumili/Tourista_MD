// models/guide.go
package models

type Guide struct {
    ID           string   `json:"id" firestore:"-"`
    FullName     string   `json:"fullName" firestore:"fullName"`
    PhoneNumber  string   `json:"phoneNumber" firestore:"phoneNumber"`
    Email        string   `json:"email" firestore:"email"`
    PhotoProfile string   `json:"photoProfile" firestore:"photoProfile"`
    WilayaIDs    []int `json:"wilayaIds" firestore:"wilayaIds"`
}
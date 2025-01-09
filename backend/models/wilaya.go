// models/wilaya.go
package models

type Wilaya struct {
    ID         string `json:"id" firestore:"-"`
    WilayaName string `json:"wilayaName" firestore:"wilayaName"`
}
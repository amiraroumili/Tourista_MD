// controllers/wilaya_controller.go
package controllers

import (
    "context"
    "net/http"
    "tourista/backend/config"
    "tourista/backend/models"
    "github.com/gin-gonic/gin"
    "google.golang.org/api/iterator"
)

// GetWilayas retrieves all wilayas
func GetWilayas(c *gin.Context) {
    ctx := context.Background()
    iter := config.FirestoreClient.Collection("wilayas").Documents(ctx)
    
    var wilayas []models.Wilaya
    for {
        doc, err := iter.Next()
        if err == iterator.Done {
            break
        }
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch wilayas"})
            return
        }

        var wilaya models.Wilaya
        if err := doc.DataTo(&wilaya); err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to parse wilaya data"})
            return
        }
        wilaya.ID = doc.Ref.ID
        wilayas = append(wilayas, wilaya)
    }

    c.JSON(http.StatusOK, wilayas)
}

// AddWilaya adds a new wilaya
func AddWilaya(c *gin.Context) {
    var wilaya models.Wilaya
    if err := c.ShouldBindJSON(&wilaya); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    ctx := context.Background()
    
    // Use the provided ID as the document ID
    _, err := config.FirestoreClient.Collection("wilayas").Doc(wilaya.ID).Set(ctx, map[string]interface{}{
        "wilayaName": wilaya.WilayaName,
    })
    
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to add wilaya"})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Wilaya added successfully!"})
}


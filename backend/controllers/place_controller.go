package controllers

import (
    "context"
    "net/http"
    "tourista/backend/config"
    "tourista/backend/models"
    "github.com/gin-gonic/gin"
    "google.golang.org/api/iterator"
    "time"
)

// AddPlace adds a new place to Firestore
func AddPlace(c *gin.Context) {
    var place models.Place
    if err := c.ShouldBindJSON(&place); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    ctx := context.Background()
    place.CreatedAt = time.Now().Unix()
    
    docRef, _, err := config.FirestoreClient.Collection("places").Add(ctx, place)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to add place"})
        return
    }

    // Create notification
    notification := models.Notification{
        ID:        docRef.ID + "_notif",
        Title:     place.Name,
        Location:  place.Location,
        Date:      time.Now().Format("01/02/2006"),
        Time:      time.Now().Format("03:04 PM"),
        CreatedAt: time.Now().Unix(),
    }

    _, err = config.FirestoreClient.Collection("notifications").Doc(notification.ID).Set(ctx, notification)
    if err != nil {
        // Log the error but don't fail the place creation
        println("Failed to create notification:", err.Error())
    }

    c.JSON(http.StatusOK, gin.H{"message": "Place added successfully!", "id": docRef.ID})
}

// GetPlaces retrieves all places from Firestore
func GetPlaces(c *gin.Context) {
    ctx := context.Background()
    iter := config.FirestoreClient.Collection("places").Documents(ctx)
    
    var places []models.Place
    for {
        doc, err := iter.Next()
        if err == iterator.Done {
            break
        }
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch places"})
            return
        }

        var place models.Place
        if err := doc.DataTo(&place); err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to parse place data"})
            return
        }
        place.ID = doc.Ref.ID // Set Firestore document ID
        places = append(places, place)
    }

    c.JSON(http.StatusOK, places)
}

// UpdatePlace updates an existing place in Firestore
func UpdatePlace(c *gin.Context) {
    id := c.Param("id")
    var place models.Place
    if err := c.ShouldBindJSON(&place); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    ctx := context.Background()
    _, err := config.FirestoreClient.Collection("places").Doc(id).Set(ctx, place)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update place"})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Place updated successfully!"})
}

// DeletePlace removes a place from Firestore
func DeletePlace(c *gin.Context) {
    id := c.Param("id")

    ctx := context.Background()
    _, err := config.FirestoreClient.Collection("places").Doc(id).Delete(ctx)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete place"})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Place deleted successfully!"})
}
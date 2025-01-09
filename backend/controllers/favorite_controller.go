package controllers

import (
    "context"
    "time"
    "tourista/backend/config"
    "tourista/backend/models"
    "fmt"
    "github.com/gin-gonic/gin"
    "google.golang.org/api/iterator"
    "github.com/google/uuid"
    "net/http"
)

func AddFavorite(c *gin.Context) {
    var favorite models.Favorite
    if err := c.ShouldBindJSON(&favorite); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    // Check if already in favorites
    iter := config.FirestoreClient.Collection("favorites").Where("user_email", "==", favorite.UserEmail).Where("place_id", "==", favorite.PlaceID).Documents(context.Background())
    _, err := iter.Next()
    if err != iterator.Done {
        c.JSON(http.StatusOK, gin.H{"message": "Already in favorites"})
        return
    }

    favorite.ID = uuid.New().String()
    favorite.CreatedAt = time.Now().Unix()

    _, err = config.FirestoreClient.Collection("favorites").Doc(favorite.ID).Set(context.Background(), favorite)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Added to favorites"})
}

func RemoveFavorite(c *gin.Context) {
    var favorite models.Favorite
    if err := c.ShouldBindJSON(&favorite); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    ctx := context.Background()
    iter := config.FirestoreClient.Collection("favorites").Where("user_email", "==", favorite.UserEmail).Where("place_id", "==", favorite.PlaceID).Documents(ctx)
    doc, err := iter.Next()
    if err == iterator.Done {
        c.JSON(http.StatusNotFound, gin.H{"error": "Favorite not found"})
        return
    }

    _, err = config.FirestoreClient.Collection("favorites").Doc(doc.Ref.ID).Delete(ctx)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Removed from favorites"})
}

func GetUserFavorites(c *gin.Context) {
    userEmail := c.Query("user_email")
    if userEmail == "" {
        c.JSON(http.StatusBadRequest, gin.H{"error": "User email is required"})
        return
    }

    ctx := context.Background()
    var favorites []models.Favorite

    iter := config.FirestoreClient.Collection("favorites").Where("user_email", "==", userEmail).Documents(ctx)
    for {
        doc, err := iter.Next()
        if err == iterator.Done {
            break
        }
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
            return
        }

        var favorite models.Favorite
        doc.DataTo(&favorite)
        favorites = append(favorites, favorite)
    }

    // Get all place IDs
    var placeIDs []string
    for _, fav := range favorites {
        placeIDs = append(placeIDs, fmt.Sprintf("%d", fav.PlaceID))
    }

    // Get places from Firestore
    var places []models.Place
    for _, placeID := range placeIDs {
        doc, err := config.FirestoreClient.Collection("places").Doc(placeID).Get(ctx)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
            return
        }
        var place models.Place
        doc.DataTo(&place)
        place.IsFavorite = true
        places = append(places, place)
    }

    c.JSON(http.StatusOK, places)
}
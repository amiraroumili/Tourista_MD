package controllers

import (
    "net/http"
    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
    "tourista/backend/models"
)

type RatingController struct {
    db *gorm.DB
}

// NewRatingController initializes the RatingController with the given DB
func NewRatingController(db *gorm.DB) *RatingController {
    return &RatingController{db: db}
}

// CreateRating creates a rating if it doesn't already exist
func (rc *RatingController) CreateRating(c *gin.Context) {
    var rating models.Rating
    if err := c.ShouldBindJSON(&rating); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    // Check if user has already rated this place
    var existingRating models.Rating
    result := rc.db.Where("place_id = ? AND user_email = ?", rating.PlaceID, rating.UserEmail).First(&existingRating)
    
    if result.Error == nil {
        // If a rating already exists, return an error
        c.JSON(http.StatusBadRequest, gin.H{"error": "User has already rated this place"})
        return
    } else if result.Error != gorm.ErrRecordNotFound {
        // If there is an error other than record not found, return an internal server error
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to check existing rating"})
        return
    }

    // If no existing rating, create a new one
    if err := rc.db.Create(&rating).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create rating"})
        return
    }

    // Update the average rating in places table
    var avgRating float64
    if err := rc.db.Model(&models.Rating{}).Select("AVG(score)").Where("place_id = ?", rating.PlaceID).Scan(&avgRating).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to calculate average rating"})
        return
    }

    if err := rc.db.Model(&models.Place{}).Where("id = ?", rating.PlaceID).Update("rating", avgRating).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update place rating"})
        return
    }

    c.JSON(http.StatusOK, gin.H{"rating": rating, "average_rating": avgRating})
}
func (rc *RatingController) GetUserRating(c *gin.Context) {
    placeID := c.Query("place_id")
    userEmail := c.Query("user_email")

    var rating models.Rating
    result := rc.db.Where("place_id = ? AND user_email = ?", placeID, userEmail).First(&rating)

    if result.Error == gorm.ErrRecordNotFound {
        c.JSON(http.StatusNotFound, gin.H{"exists": false})
        return
    } else if result.Error != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to check rating"})
        return
    }

    c.JSON(http.StatusOK, gin.H{
        "exists": true,
        "rating": rating.Score,
    })
}
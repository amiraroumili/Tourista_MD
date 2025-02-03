package controllers

import (
    "tourista/backend/config"
    "tourista/backend/models"
    "github.com/gin-gonic/gin"
    "net/http"
)

// Add a new place
func AddPlace(c *gin.Context) {
    var place models.Place
    if err := c.ShouldBindJSON(&place); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    config.DB.Create(&place)
    c.JSON(http.StatusOK, gin.H{"message": "Place added successfully!"})
}

// Get all places
func GetPlaces(c *gin.Context) {
    var places []models.Place
    config.DB.Find(&places)
    c.JSON(http.StatusOK, places)
}

// Update a place
func UpdatePlace(c *gin.Context) {
    var place models.Place
    id := c.Param("id")
    if err := config.DB.Where("id = ?", id).First(&place).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Place not found"})
        return
    }
    if err := c.ShouldBindJSON(&place); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    config.DB.Save(&place)
    c.JSON(http.StatusOK, gin.H{"message": "Place updated successfully!"})
}

// Delete a place
func DeletePlace(c *gin.Context) {
    var place models.Place
    id := c.Param("id")
    if err := config.DB.Where("id = ?", id).First(&place).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Place not found"})
        return
    }
    config.DB.Delete(&place)
    c.JSON(http.StatusOK, gin.H{"message": "Place deleted successfully!"})
}

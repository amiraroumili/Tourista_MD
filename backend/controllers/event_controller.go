// controllers/event_controller.go
package controllers

import (
    "tourista/backend/config"
    "tourista/backend/models"
    "github.com/gin-gonic/gin"
    "net/http"
)

// GetEventsHandler fetches all events
func GetEventsHandler(c *gin.Context) {
    var events []models.Event
    if err := config.DB.Find(&events).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch events"})
        return
    }
    c.JSON(http.StatusOK, events)
}

// AddEventHandler adds a new event
func AddEventHandler(c *gin.Context) {
    var event models.Event
    if err := c.ShouldBindJSON(&event); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    if err := config.DB.Create(&event).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to add event"})
        return
    }

    c.JSON(http.StatusCreated, event)
}

// GetEventHandler fetches a specific event by its ID
func GetEventHandler(c *gin.Context) {
    id := c.Param("id")
    var event models.Event
    
    if err := config.DB.First(&event, id).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Event not found"})
        return
    }
    
    c.JSON(http.StatusOK, event)
}

// UpdateEventHandler updates an existing event
func UpdateEventHandler(c *gin.Context) {
    id := c.Param("id")
    var event models.Event
    
    // Check if event exists
    if err := config.DB.First(&event, id).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Event not found"})
        return
    }
    
    // Bind updated data
    if err := c.ShouldBindJSON(&event); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    
    // Save updates
    if err := config.DB.Save(&event).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update event"})
        return
    }
    
    c.JSON(http.StatusOK, event)
}

// DeleteEventHandler deletes an event
func DeleteEventHandler(c *gin.Context) {
    id := c.Param("id")
    var event models.Event
    
    // Check if event exists
    if err := config.DB.First(&event, id).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Event not found"})
        return
    }
    
    // Delete the event
    if err := config.DB.Delete(&event).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete event"})
        return
    }
    
    c.JSON(http.StatusOK, gin.H{"message": "Event deleted successfully"})
}
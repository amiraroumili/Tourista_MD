package controllers

import (
    "context"
    "net/http"
    "tourista/backend/config"
    "tourista/backend/models"
    "github.com/gin-gonic/gin"
    "google.golang.org/api/iterator"
    "strconv"
    "time"
  
)

func GetEventsHandler(c *gin.Context) {
    ctx := context.Background()
    iter := config.FirestoreClient.Collection("events").Documents(ctx)
    
    var events []models.Event
    for {
        doc, err := iter.Next()
        if err == iterator.Done {
            break
        }
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch events"})
            return
        }

        var event models.Event
        if err := doc.DataTo(&event); err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to parse event data"})
            return
        }
        if _, err := strconv.ParseUint(doc.Ref.ID, 10, 32); err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to parse event ID"})
            return
        }
        event.ID = doc.Ref.ID
        events = append(events, event)
    }

    c.JSON(http.StatusOK, events)
}

func AddEventHandler(c *gin.Context) {
    var event models.Event
    if err := c.ShouldBindJSON(&event); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    ctx := context.Background()
    event.CreatedAt = time.Now().Unix()
    
    docRef, _, err := config.FirestoreClient.Collection("events").Add(ctx, event)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to add event"})
        return
    }

    // Create notification
    notification := models.Notification{
        ID:        docRef.ID + "_notif",
        Title:     "New Event Added: " + event.Title,
        Location:  event.Location,
        Date:      time.Now().Format("01/02/2006"),
        Time:      time.Now().Format("03:04 PM"),
        CreatedAt: time.Now().Unix(),
    }

    _, err = config.FirestoreClient.Collection("notifications").Doc(notification.ID).Set(ctx, notification)
    if err != nil {
        // Log the error but don't fail the event creation
        println("Failed to create notification:", err.Error())
    }

    event.ID = docRef.ID
    c.JSON(http.StatusCreated, event)
}

func GetEventHandler(c *gin.Context) {
    id := c.Param("id")
    ctx := context.Background()

    doc, err := config.FirestoreClient.Collection("events").Doc(id).Get(ctx)
    if err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Event not found"})
        return
    }

    var event models.Event
    if err := doc.DataTo(&event); err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to parse event data"})
        return
    }
    if _, err := strconv.ParseUint(doc.Ref.ID, 10, 32); err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to parse event ID"})
        return
    }
    event.ID = doc.Ref.ID
    
    c.JSON(http.StatusOK, event)
}

func UpdateEventHandler(c *gin.Context) {
    id := c.Param("id")
    var event models.Event
    
    if err := c.ShouldBindJSON(&event); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    ctx := context.Background()
    _, err := config.FirestoreClient.Collection("events").Doc(id).Set(ctx, event)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update event"})
        return
    }
    
    c.JSON(http.StatusOK, event)
}

func DeleteEventHandler(c *gin.Context) {
    id := c.Param("id")
    
    ctx := context.Background()
    _, err := config.FirestoreClient.Collection("events").Doc(id).Delete(ctx)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete event"})
        return
    }
    
    c.JSON(http.StatusOK, gin.H{"message": "Event deleted successfully"})
}
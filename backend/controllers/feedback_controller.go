package controllers

import (
    "context"
    "time"
    "tourista/backend/config"
    "tourista/backend/models"
    "github.com/gin-gonic/gin"
    "google.golang.org/api/iterator"
    "github.com/google/uuid"
    "net/http"
    "cloud.google.com/go/firestore"
)

// Feedback Controllers
func SubmitFeedback(c *gin.Context) {
    var feedback models.Feedback
    if err := c.ShouldBindJSON(&feedback); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    feedback.ID = uuid.New().String()
    feedback.CreatedAt = time.Now().Unix()

    _, err := config.FirestoreClient.Collection("feedback").Doc(feedback.ID).Set(context.Background(), feedback)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    c.JSON(http.StatusOK, feedback)
}

func GetFeedback(c *gin.Context) {
    ctx := context.Background()
    var feedbacks []models.Feedback

    iter := config.FirestoreClient.Collection("feedback").OrderBy("created_at", firestore.Desc).Documents(ctx)
    for {
        doc, err := iter.Next()
        if err == iterator.Done {
            break
        }
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
            return
        }

        var feedback models.Feedback
        doc.DataTo(&feedback)
        feedbacks = append(feedbacks, feedback)
    }

    c.JSON(http.StatusOK, feedbacks)
}
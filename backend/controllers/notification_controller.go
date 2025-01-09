package controllers
  
import (
    "context"
    "tourista/backend/config"
    "tourista/backend/models"
    "github.com/gin-gonic/gin"
    "google.golang.org/api/iterator"
    "net/http"
    "cloud.google.com/go/firestore"
)

// Notification Controllers
func GetNotifications(c *gin.Context) {
    ctx := context.Background()
    var notifications []models.Notification

    iter := config.FirestoreClient.Collection("notifications").OrderBy("created_at", firestore.Desc).Documents(ctx)
    for {
        doc, err := iter.Next()
        if err == iterator.Done {
            break
        }
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
            return
        }

        var notification models.Notification
        doc.DataTo(&notification)
        notifications = append(notifications, notification)
    }

    c.JSON(http.StatusOK, notifications)
}

func DeleteNotification(c *gin.Context) {
    id := c.Param("id")
    ctx := context.Background()

    _, err := config.FirestoreClient.Collection("notifications").Doc(id).Delete(ctx)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Notification deleted successfully!"})
}
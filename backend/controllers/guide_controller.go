// controllers/guide_controller.go
package controllers

import (
    "context"
    "net/http"
    "tourista/backend/config"
    "tourista/backend/models"
    "github.com/gin-gonic/gin"
    "google.golang.org/api/iterator"
)

func GetGuidesByWilaya(c *gin.Context) {
    wilayaID := c.Param("id")
    ctx := context.Background()
    
    // Query guides where wilayaIds array contains the specified wilayaID
    iter := config.FirestoreClient.Collection("guides").Where("wilayaIds", "array-contains", wilayaID).Documents(ctx)
    
    var guidesResponse []map[string]interface{}
    
    for {
        doc, err := iter.Next()
        if err == iterator.Done {
            break
        }
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch guides"})
            return
        }

        var guide models.Guide
        if err := doc.DataTo(&guide); err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to parse guide data"})
            return
        }
        guide.ID = doc.Ref.ID

        // Create response data with proper formatting
        photoURL := guide.PhotoProfile
        if photoURL == "" {
            photoURL = "default-profile.jpg"
        }

        guideData := map[string]interface{}{
            "id":       guide.ID,
            "name":     guide.FullName,
            "email":    guide.Email,
            "phone":    guide.PhoneNumber,
            "imageUrl": photoURL,
        }
        guidesResponse = append(guidesResponse, guideData)
    }

    c.JSON(http.StatusOK, guidesResponse)
}
// AddGuide adds a new guide to Firestore
func AddGuide(c *gin.Context) {
    var guide models.Guide
    if err := c.ShouldBindJSON(&guide); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    ctx := context.Background()
    _, _, err := config.FirestoreClient.Collection("guides").Add(ctx, guide)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to add guide"})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Guide added successfully!"})
}
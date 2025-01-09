// feedback_routes.go
package routes

import (
    "github.com/gin-gonic/gin"
    "tourista/backend/controllers"
)

func FeedbackRoutes(r *gin.Engine) {
    feedbackGroup := r.Group("/feedback")
    {
        feedbackGroup.POST("", controllers.SubmitFeedback)
        feedbackGroup.GET("", controllers.GetFeedback)
    }
}
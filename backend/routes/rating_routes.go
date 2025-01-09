package routes

import (
    "github.com/gin-gonic/gin"
    "tourista/backend/controllers"
)

// SetupRatingRoutes registers the routes for the rating controller
func SetupRatingRoutes(router *gin.Engine, ratingController *controllers.RatingController) {
    ratings := router.Group("/api/ratings")
    {
        ratings.POST("", ratingController.CreateRating)
        ratings.POST("/", ratingController.CreateRating)
        ratings.GET("/user", ratingController.GetUserRating) // Add this new route
    }
}
package routes

import (
    "tourista/backend/controllers"
    "github.com/gin-gonic/gin"
)

func PlaceRoutes(r *gin.Engine) {
    r.POST("/add-place", controllers.AddPlace)
    r.GET("/places", controllers.GetPlaces)
    r.PUT("/update-place/:id", controllers.UpdatePlace)
    r.DELETE("/delete-place/:id", controllers.DeletePlace)
}

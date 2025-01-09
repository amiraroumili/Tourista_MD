// routes/guide_routes.go
package routes

import (
    "github.com/gin-gonic/gin"
    "tourista/backend/controllers"
)

func GuideRoutes(r *gin.Engine) {
    guideRoutes := r.Group("/api/guides")
    {
        guideRoutes.GET("/wilaya/:id", controllers.GetGuidesByWilaya)
        guideRoutes.POST("/add", controllers.AddGuide) // New route for adding a guide

    }
}
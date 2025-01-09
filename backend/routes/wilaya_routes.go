// routes/wilaya_routes.go
package routes

import (
    "tourista/backend/controllers"
    "github.com/gin-gonic/gin"
)

func WilayaRoutes(r *gin.Engine) {
    wilayaRoutes := r.Group("/api/wilayas")
    {
        wilayaRoutes.GET("/", controllers.GetWilayas)
        wilayaRoutes.POST("/", controllers.AddWilaya)
    }
}
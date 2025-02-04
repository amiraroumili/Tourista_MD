// routes/event_routes.go
package routes

import (
    "tourista/backend/controllers"
    "github.com/gin-gonic/gin"
)

// EventRoutes defines the routes for handling events
func EventRoutes(r *gin.Engine) {
    // Legacy routes without prefix
    r.GET("/events", controllers.GetEventsHandler)
    r.POST("/events", controllers.AddEventHandler)
    r.GET("/events/:id", controllers.GetEventHandler)
    r.PUT("/events/:id", controllers.UpdateEventHandler)
    r.DELETE("/events/:id", controllers.DeleteEventHandler)

    // API versioned routes
    v1 := r.Group("/api/v1")
    {
        v1.GET("/events", controllers.GetEventsHandler)
        v1.POST("/events", controllers.AddEventHandler)
        v1.GET("/events/:id", controllers.GetEventHandler)
        v1.PUT("/events/:id", controllers.UpdateEventHandler)
        v1.DELETE("/events/:id", controllers.DeleteEventHandler)
    }
}
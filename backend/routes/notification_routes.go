// notification_routes.go
package routes

import (
    "github.com/gin-gonic/gin"
    "tourista/backend/controllers"
)

func NotificationRoutes(r *gin.Engine) {
    notificationGroup := r.Group("/notifications")
    {
        notificationGroup.GET("", controllers.GetNotifications)
        notificationGroup.DELETE("/:id", controllers.DeleteNotification)
    }
}
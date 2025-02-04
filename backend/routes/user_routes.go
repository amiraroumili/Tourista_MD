// routes/user_routes.go
package routes

import (
    "tourista/backend/controllers"
    "github.com/gin-gonic/gin"
)

// UserRoutes defines the routes for user management
func UserRoutes(r *gin.Engine) {
    api := r.Group("/api/v1")
    {
        api.POST("/users/register", controllers.RegisterHandler)
        api.POST("/users/login", controllers.LoginHandler)
        api.PUT("/users/update", controllers.UpdateUserHandler)
        api.PUT("/users/update-password", controllers.UpdatePasswordHandler)
        api.GET("/users/:email", controllers.GetUserHandler)
		api.GET("/users", controllers.GetAllUsersHandler)
    }
}

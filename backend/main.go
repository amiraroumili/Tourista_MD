<<<<<<< HEAD
// main.go
=======
>>>>>>> 5ddc415 (Refactor backend structure and update dependencies)
package main

import (
    "tourista/backend/config"
    "tourista/backend/routes"
    "github.com/gin-gonic/gin"
<<<<<<< HEAD
    "github.com/gin-contrib/cors"
)

// Update main.go to include user routes
func main() {
    r := gin.Default()

    // Add CORS middleware
    r.Use(cors.New(cors.Config{
        AllowAllOrigins: true,
        AllowMethods:    []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
        AllowHeaders:    []string{"Origin", "Content-Type", "Accept", "Authorization"},
    }))

=======
)

func main() {
    // Initialize Gin router
    r := gin.Default()

>>>>>>> 5ddc415 (Refactor backend structure and update dependencies)
    // Connect to database
    config.ConnectDatabase()

    // Define routes
<<<<<<< HEAD
    routes.UserRoutes(r)
    routes.PlaceRoutes(r)
    routes.EventRoutes(r)

=======
    routes.PlaceRoutes(r)

    // Start the server
>>>>>>> 5ddc415 (Refactor backend structure and update dependencies)
    r.Run(":8081")
}

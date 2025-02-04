// main.go
package main

import (
    "tourista/backend/config"
    "tourista/backend/routes"
    "github.com/gin-gonic/gin"
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

    // Connect to database
    config.ConnectDatabase()

    // Define routes
    routes.UserRoutes(r)
    routes.PlaceRoutes(r)
    routes.EventRoutes(r)

    r.Run(":8081")
}

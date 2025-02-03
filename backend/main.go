package main

import (
    "tourista/backend/config"
    "tourista/backend/routes"
    "github.com/gin-gonic/gin"
)

func main() {
    // Initialize Gin router
    r := gin.Default()

    // Connect to database
    config.ConnectDatabase()

    // Define routes
    routes.PlaceRoutes(r)

    // Start the server
    r.Run(":8081")
}

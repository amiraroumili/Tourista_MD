package main

import (
    "tourista/backend/config"
    "tourista/backend/routes"
    "github.com/gin-gonic/gin"
    "github.com/gin-contrib/cors"
    "log"
)

func main() {
    r := gin.Default()

    // Add CORS middleware
    r.Use(cors.New(cors.Config{
        AllowAllOrigins: true,
        AllowMethods:    []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
        AllowHeaders:    []string{"Origin", "Content-Type", "Accept", "Authorization"},
    }))
    // Initialize Cloudinary client
    config.InitCloudinary()
    if config.CloudinaryClient == nil {
        log.Fatal("Failed to initialize Cloudinary client")
    }
    // Serve static files for profile images
    r.Static("/uploads", "./uploads")

    // Connect to database
    config.ConnectDatabase()
    defer config.CloseDatabase()

    // Define routes
    routes.UserRoutes(r)
    routes.PlaceRoutes(r)
    routes.EventRoutes(r)
    routes.GuideRoutes(r)
    routes.WilayaRoutes(r)
    routes.FeedbackRoutes(r)
    routes.FavoriteRoutes(r)
    routes.NotificationRoutes(r)
    
    r.Run(":8081")

    
    
}
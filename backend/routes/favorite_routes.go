// favorite_routes.go
package routes

import (
    "github.com/gin-gonic/gin"
    "tourista/backend/controllers"
)

func FavoriteRoutes(r *gin.Engine) {
    favoriteGroup := r.Group("/favorites")
    {
        favoriteGroup.POST("", controllers.AddFavorite)
        favoriteGroup.DELETE("", controllers.RemoveFavorite)
        favoriteGroup.GET("", controllers.GetUserFavorites)
    }
}
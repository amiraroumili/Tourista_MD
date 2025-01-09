// routes/comments_routes.go
package routes

import (
	"tourista/backend/controllers"

	"github.com/gin-gonic/gin"
)

func SetupCommentRoutes(r *gin.Engine, cc *controllers.CommentController) {
	comments := r.Group("/api")
	{
		comments.POST("/comments", cc.CreateComment)
		comments.GET("/places/:id/comments", cc.GetPlaceComments)
		comments.PUT("/comments/:id", cc.UpdateComment)
		comments.DELETE("/comments/:id", cc.DeleteComment)
	}
}
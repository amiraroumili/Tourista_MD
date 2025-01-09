// controllers/comments_controller.go
package controllers

import (
	"net/http"
	"strconv"
	"time"
	"tourista/backend/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type CommentController struct {
	db *gorm.DB
}

func NewCommentController(db *gorm.DB) *CommentController {
	return &CommentController{db: db}
}

// CreateComment handles the creation of a new comment
func (cc *CommentController) CreateComment(c *gin.Context) {
	var input struct {
		Content   string `json:"content" binding:"required"`
		PlaceID   uint   `json:"place_id" binding:"required"`
		UserEmail string `json:"user_email" binding:"required,email"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Verify that the place exists
	var place models.Place
	if err := cc.db.First(&place, input.PlaceID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Place not found"})
		return
	}

	// Verify that the user exists
	var user models.User
	if err := cc.db.Where("email = ?", input.UserEmail).First(&user).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	comment := models.Comment{
		Content:   input.Content,
		PlaceID:   input.PlaceID,
		UserEmail: input.UserEmail,
	}

	if err := cc.db.Create(&comment).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create comment"})
		return
	}

	c.JSON(http.StatusCreated, comment)
}

// GetPlaceComments retrieves all comments for a specific place
func (cc *CommentController) GetPlaceComments(c *gin.Context) {
	placeID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid place ID"})
		return
	}

	var comments []struct {
		ID        uint      `json:"id"`
		Content   string    `json:"content"`
		CreatedAt time.Time `json:"created_at"`
		UserEmail string    `json:"user_email"`
		UserName  string    `json:"user_name"`
		UserRating float64  `json:"user_rating"`
	}

	// Updated query to use the correct table name 'rating' instead of 'ratings'
	query := `
		SELECT 
			c.id,
			c.content,
			c.created_at,
			c.user_email,
			COALESCE(u.first_name || ' ' || u.family_name, u.email) as user_name,
			COALESCE(r.score, 0) as user_rating
		FROM comments c
		JOIN users u ON c.user_email = u.email
		LEFT JOIN rating r ON r.user_email = c.user_email AND r.place_id = c.place_id
		WHERE c.place_id = ? AND c.deleted_at IS NULL
		ORDER BY c.created_at DESC
	`

	if err := cc.db.Raw(query, placeID).Scan(&comments).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch comments"})
		return
	}

	c.JSON(http.StatusOK, comments)
}

// UpdateComment handles updating an existing comment
func (cc *CommentController) UpdateComment(c *gin.Context) {
	commentID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid comment ID"})
		return
	}

	var input struct {
		Content string `json:"content" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var comment models.Comment
	if err := cc.db.First(&comment, commentID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Comment not found"})
		return
	}

	comment.Content = input.Content
	if err := cc.db.Save(&comment).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update comment"})
		return
	}

	c.JSON(http.StatusOK, comment)
}

// DeleteComment handles the deletion of a comment
func (cc *CommentController) DeleteComment(c *gin.Context) {
	commentID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid comment ID"})
		return
	}

	if err := cc.db.Delete(&models.Comment{}, commentID).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete comment"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Comment deleted successfully"})
}
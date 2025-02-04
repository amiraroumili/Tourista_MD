// controllers/user_controller.go
package controllers

import (
    "tourista/backend/config"
    "tourista/backend/models"
    "github.com/gin-gonic/gin"
    "golang.org/x/crypto/bcrypt"
    "net/http"
)

// RegisterHandler handles user registration
func RegisterHandler(c *gin.Context) {
    var user models.User
    if err := c.ShouldBindJSON(&user); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    // Hash password before storing
    hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to process password"})
        return
    }
    user.Password = string(hashedPassword)

    // Check if user already exists
    var existingUser models.User
    if err := config.DB.Where("email = ?", user.Email).First(&existingUser).Error; err == nil {
        c.JSON(http.StatusConflict, gin.H{"error": "User already exists with this email"})
        return
    }

    // Create new user
    if err := config.DB.Create(&user).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user"})
        return
    }

    // Don't return the password in the response
    user.Password = ""
    c.JSON(http.StatusCreated, user)
}

// LoginHandler handles user login
func LoginHandler(c *gin.Context) {
    var loginData struct {
        Email    string `json:"email" binding:"required,email"`
        Password string `json:"password" binding:"required"`
    }

    if err := c.ShouldBindJSON(&loginData); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    var user models.User
    if err := config.DB.Where("email = ?", loginData.Email).First(&user).Error; err != nil {
        c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
        return
    }

    // Check password
    if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(loginData.Password)); err != nil {
        c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
        return
    }

    // Don't return the password in the response
    user.Password = ""
    c.JSON(http.StatusOK, user)
}

// UpdateUserHandler handles user profile updates
func UpdateUserHandler(c *gin.Context) {
    var updateData models.User
    if err := c.ShouldBindJSON(&updateData); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    var user models.User
    if err := config.DB.Where("email = ?", updateData.Email).First(&user).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
        return
    }

    // Update fields
    user.FirstName = updateData.FirstName
    user.FamilyName = updateData.FamilyName
    user.Wilaya = updateData.Wilaya

    if err := config.DB.Save(&user).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update user"})
        return
    }

    user.Password = "" // Don't return password
    c.JSON(http.StatusOK, user)
}

// UpdatePasswordHandler handles password updates
func UpdatePasswordHandler(c *gin.Context) {
    var passwordData struct {
        Email       string `json:"email" binding:"required,email"`
        OldPassword string `json:"oldPassword" binding:"required"`
        NewPassword string `json:"newPassword" binding:"required"`
    }

    if err := c.ShouldBindJSON(&passwordData); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    var user models.User
    if err := config.DB.Where("email = ?", passwordData.Email).First(&user).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
        return
    }

    // Verify old password
    if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(passwordData.OldPassword)); err != nil {
        c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid old password"})
        return
    }

    // Hash new password
    hashedPassword, err := bcrypt.GenerateFromPassword([]byte(passwordData.NewPassword), bcrypt.DefaultCost)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to process new password"})
        return
    }

    // Update password
    if err := config.DB.Model(&user).Update("password", string(hashedPassword)).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update password"})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Password updated successfully"})
}

// GetUserHandler retrieves user profile
func GetUserHandler(c *gin.Context) {
    email := c.Param("email")
    var user models.User
    
    if err := config.DB.Where("email = ?", email).First(&user).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
        return
    }

    user.Password = "" // Don't return password
    c.JSON(http.StatusOK, user)
}

func GetAllUsersHandler(c *gin.Context) {
    var users []models.User

    // Fetch all users from the database
    if err := config.DB.Find(&users).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch users"})
        return
    }

    // Remove passwords from the response
    for i := range users {
        users[i].Password = ""
    }

	// Return the users as JSON
    c.JSON(http.StatusOK, users)
}
package controllers

import (
    "context"
    "net/http"
    "fmt"
    "tourista/backend/config"
    "tourista/backend/models"
    "tourista/backend/Cloudinary"
    "github.com/gin-gonic/gin"
    "golang.org/x/crypto/bcrypt"
    "google.golang.org/api/iterator"
    "cloud.google.com/go/firestore"
)

func RegisterHandler(c *gin.Context) {
    var user models.User
    if err := c.ShouldBindJSON(&user); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    ctx := context.Background()

    // Check if user already exists
    iter := config.FirestoreClient.Collection("users").Where("Email", "==", user.Email).Documents(ctx)
    snapshot, err := iter.Next()
    if err == nil && snapshot != nil {
        c.JSON(http.StatusConflict, gin.H{"error": "User already exists with this email"})
        return
    }

    // Hash password
    hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to process password"})
        return
    }
    user.Password = string(hashedPassword)

    // Add user to Firestore
    docRef, _, err := config.FirestoreClient.Collection("users").Add(ctx, user)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user"})
        return
    }

    user.ID = docRef.ID
    user.Password = "" // Don't return password
    c.JSON(http.StatusCreated, user)
}

func LoginHandler(c *gin.Context) {
    var loginData struct {
        Email    string `json:"email" binding:"required,email"`
        Password string `json:"password" binding:"required"`
    }

    if err := c.ShouldBindJSON(&loginData); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    ctx := context.Background()
    iter := config.FirestoreClient.Collection("users").Where("Email", "==", loginData.Email).Documents(ctx)
    snapshot, err := iter.Next()
    if err != nil {
        c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
        return
    }

    var user models.User
    if err := snapshot.DataTo(&user); err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to parse user data"})
        return
    }

    // Check password
    if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(loginData.Password)); err != nil {
        c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
        return
    }

    user.ID = snapshot.Ref.ID
    user.Password = "" // Don't return password
    c.JSON(http.StatusOK, user)
}

func UpdateUserHandler(c *gin.Context) {
    var updateData struct {
        Email      string `json:"email" binding:"required,email"`
        FirstName  string `json:"firstName" binding:"required"`
        FamilyName string `json:"familyName" binding:"required"`
        Wilaya     string `json:"wilaya" binding:"required"`
    }

    if err := c.ShouldBindJSON(&updateData); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    ctx := context.Background()
    iter := config.FirestoreClient.Collection("users").Where("Email", "==", updateData.Email).Documents(ctx)
    snapshot, err := iter.Next()
    if err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
        return
    }


    // Update user in Firestore
    _, err = snapshot.Ref.Update(ctx, []firestore.Update{
        {Path: "FirstName", Value: updateData.FirstName},
        {Path: "FamilyName", Value: updateData.FamilyName},
        {Path: "Wilaya", Value: updateData.Wilaya},
    })
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update user"})
        return
    }

    var user models.User
    snapshot.DataTo(&user)
    user.ID = snapshot.Ref.ID
    user.Password = ""
    c.JSON(http.StatusOK, user)
}

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

    ctx := context.Background()
    iter := config.FirestoreClient.Collection("users").Where("Email", "==", passwordData.Email).Documents(ctx)
    snapshot, err := iter.Next()
    if err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
        return
    }

    var user models.User
    if err := snapshot.DataTo(&user); err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to parse user data"})
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

    // Update password in Firestore
    _, err = snapshot.Ref.Update(ctx, []firestore.Update{
        {Path: "Password", Value: string(hashedPassword)},
    })
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update password"})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Password updated successfully"})
}

func GetUserHandler(c *gin.Context) {
    email := c.Param("email")
    ctx := context.Background()

    iter := config.FirestoreClient.Collection("users").Where("Email", "==", email).Documents(ctx)
    snapshot, err := iter.Next()
    if err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
        return
    }

    var user models.User
    if err := snapshot.DataTo(&user); err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to parse user data"})
        return
    }

    user.ID = snapshot.Ref.ID
    user.Password = "" // Don't return password
    c.JSON(http.StatusOK, user)
}

func GetAllUsersHandler(c *gin.Context) {
    ctx := context.Background()
    iter := config.FirestoreClient.Collection("users").Documents(ctx)
    
    var users []models.User
    for {
        doc, err := iter.Next()
        if err == iterator.Done {
            break
        }
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch users"})
            return
        }

        var user models.User
        if err := doc.DataTo(&user); err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to parse user data"})
            return
        }
        user.ID = doc.Ref.ID
        user.Password = "" // Remove password before sending
        users = append(users, user)
    }

    c.JSON(http.StatusOK, users)
}

type ProfileImageRequest struct {
    Email string `json:"email" binding:"required"`
    Image string `json:"image" binding:"required"` // base64 encoded image
}

func UpdateProfileImageHandler(c *gin.Context) {
    var imageData ProfileImageRequest
    if err := c.ShouldBindJSON(&imageData); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("Invalid request format: %v", err)})
        return
    }

    // Upload to Cloudinary first
    imageURL, err := cloudinary.UploadProfileImage(config.CloudinaryClient, imageData.Email, imageData.Image)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": fmt.Sprintf("Failed to upload image: %v", err)})
        return
    }

    // Update user profile in Firestore with new image URL
    ctx := context.Background()
    query := config.FirestoreClient.Collection("users").Where("email", "==", imageData.Email)
    iter := query.Documents(ctx)
    doc, err := iter.Next()
    
    if err != nil {
        // Even if we can't update Firestore, return the Cloudinary URL
        c.JSON(http.StatusOK, gin.H{
            "message": "Image uploaded successfully but user record not updated",
            "imageUrl": imageURL,
        })
        return
    }

    _, err = doc.Ref.Update(ctx, []firestore.Update{
        {Path: "profileImage", Value: imageURL},
    })

    if err != nil {
        // Even if update fails, return the Cloudinary URL
        c.JSON(http.StatusOK, gin.H{
            "message": "Image uploaded successfully but user record not updated",
            "imageUrl": imageURL,
        })
        return
    }

    c.JSON(http.StatusOK, gin.H{
        "message": "Profile image updated successfully",
        "imageUrl": imageURL,
    })
}

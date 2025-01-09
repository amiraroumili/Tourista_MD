package cloudinary

import (
	"bytes"
	"context"
	"encoding/base64"
	"fmt"
	"time"
	"strings"
	"path/filepath"
	"github.com/cloudinary/cloudinary-go/v2"
	"github.com/cloudinary/cloudinary-go/v2/api/uploader"
	"log"
)

var CloudinaryClient *cloudinary.Cloudinary

type CloudinaryConfig struct {
	CloudName   string
	APIKey      string
	APISecret   string
}


func InitCloudinary() {
    var err error
    cloudName := "dloyqdnom"
    apiKey := "288339188241434"
    apiSecret := "EsIFypz07yKtX7FN-BATvTuLTxc"

    CloudinaryClient, err = cloudinary.NewFromParams(cloudName, apiKey, apiSecret)
    if err != nil {
        log.Printf("Failed to initialize Cloudinary: %v", err)
        return
    }

    log.Println("Cloudinary initialized successfully")
}

func UploadProfileImage(cld *cloudinary.Cloudinary, userEmail string, base64Image string) (string, error) {
    if cld == nil {
        return "", fmt.Errorf("cloudinary client is nil")
    }

    // Remove data URL prefix if present
    base64Data := base64Image
    if strings.Contains(base64Image, ",") {
        base64Data = strings.Split(base64Image, ",")[1]
    }

    // Decode base64 image
    imageData, err := base64.StdEncoding.DecodeString(base64Data)
    if err != nil {
        return "", fmt.Errorf("error decoding base64 image: %v", err)
    }

    ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
    defer cancel()

    // Create a unique public ID for the image
    timestamp := time.Now().UnixNano()
    publicID := fmt.Sprintf("profile_%s_%d", strings.Replace(userEmail, "@", "_", -1), timestamp)

    // Upload to Cloudinary
    uploadResult, err := cld.Upload.Upload(
        ctx,
        bytes.NewReader(imageData),
        uploader.UploadParams{
            PublicID: publicID,
            Folder:   "tourista_profiles",
            ResourceType: "image",
            Transformation: "q_auto:good", // Add automatic quality optimization
        },
    )

    if err != nil {
        return "", fmt.Errorf("error uploading to cloudinary: %v", err)
    }

    return uploadResult.SecureURL, nil
}


func DeleteProfileImage(cld *cloudinary.Cloudinary, imageURL string) error {
    if cld == nil {
        return fmt.Errorf("cloudinary client is nil")
    }

    // Extract public ID from URL
    publicID := extractPublicIDFromURL(imageURL)
    if publicID == "" {
        return fmt.Errorf("invalid cloudinary URL")
    }

    ctx := context.Background()
    _, err := cld.Upload.Destroy(ctx, uploader.DestroyParams{PublicID: publicID})
    return err
}

func extractPublicIDFromURL(imageURL string) string {
	// Example Cloudinary URL: https://res.cloudinary.com/dloyqdnom/image/upload/v1234/tourista_profiles/profile_user@email.com_timestamp.jpg
	parts := strings.Split(imageURL, "/")
	if len(parts) < 2 {
		return ""
	}
	filename := parts[len(parts)-1]
	return fmt.Sprintf("tourista_profiles/%s", strings.TrimSuffix(filename, filepath.Ext(filename)))
}
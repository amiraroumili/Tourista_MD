package config

import (
	"log"
	//"tourista/backend/models"
	cld "github.com/cloudinary/cloudinary-go/v2" 
	"firebase.google.com/go"
    "cloud.google.com/go/firestore"
    "google.golang.org/api/option"
    "context"
)

var (
	CloudinaryClient *cld.Cloudinary
	FirestoreClient *firestore.Client
	
)

// InitCloudinary initializes the Cloudinary client
func InitCloudinary() {
	cloudName := "dloyqdnom"
	apiKey := "288339188241434"
	apiSecret := "EsIFypz07yKtX7FN-BATvTuLTxc"

	cld, err := cld.NewFromParams(cloudName, apiKey, apiSecret) // Corrected function call
	if err != nil {
		log.Fatalf("Failed to initialize Cloudinary: %v", err)
	}

	CloudinaryClient = cld
	log.Println("Cloudinary connection established successfully")
}

func ConnectDatabase() {
    ctx := context.Background()

    // Use the service account key file you provided
    opt := option.WithCredentialsFile("C:\\Users\\AMIRA\\Desktop\\Tourista\\NEEEW\\GO\\backend\\tourista-backend-firebase-adminsdk-fbsvc-73e031bff1.json")
    
    app, err := firebase.NewApp(ctx, nil, opt)
    if err != nil {
        log.Fatalf("Failed to initialize Firebase app: %v", err)
    }

    FirestoreClient, err = app.Firestore(ctx)
    if err != nil {
        log.Fatalf("Failed to connect to Firestore: %v", err)
    }

    log.Println("Firestore connection established successfully")
}

// CloseDatabase closes the Firestore connection
func CloseDatabase() {
    if FirestoreClient != nil {
        FirestoreClient.Close()
    }
}
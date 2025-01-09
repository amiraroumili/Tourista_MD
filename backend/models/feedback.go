package models

// Feedback represents user feedback
type Feedback struct {
    ID                    string `json:"id" firestore:"id"`
    UsageFrequency       string `json:"usage_frequency" firestore:"usage_frequency"`
    Motivation           string `json:"motivation" firestore:"motivation"`
    MostUsedFeature      string `json:"most_used_feature" firestore:"most_used_feature"`
    ReceivePersonalFollowup bool `json:"receive_personal_followup" firestore:"receive_personal_followup"`
    CreatedAt            int64  `json:"created_at" firestore:"created_at"`
}
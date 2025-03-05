import Foundation

// API Endpoint:
/*
 URL: http://localhost:8080/campaigns
 
 Request Body: [
 {
     "owner": "0x1234567890abcdef",
     "title": "Community Playground",
     "description": "Building a new playground for local children",
     "target": 50000.00,
     "deadline": "2024-12-31T23:59:59Z",
     "amountCollected": 0,
     "image": "https://example.com/playground.jpg"
 }]
 */

struct CreateCampaignRequest: Codable {
    let owner: String
    let title: String
    let description: String
    let target: Double
    let deadline: Date
    let image: String?
    let amountCollected: Double
}

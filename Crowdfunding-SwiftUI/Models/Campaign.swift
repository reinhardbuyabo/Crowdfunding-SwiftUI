
import Foundation

// Response Body:
/*
 API Endpoint: http://localhost:8080/campaigns
 [
     {
         "id": 1,
         "owner": "0x1234567890abcdef",
         "title": "Community Playground",
         "description": "Building a new playground for local children",
         "target": 50000,
         "deadline": "2024-12-31T23:59:59Z",
         "amountCollected": 0,
         "image": "https://example.com/playground.jpg"
     }
 ]
*/
import Foundation

struct Campaign: Identifiable, Codable {
    let id: Int
    let owner: String
    let title: String
    let description: String
    let target: Double
    let deadline: Date
    var amountCollected: Double
    let image: String?
    
    var status: CampaignStatus {
        if amountCollected >= target {
            return .completed
        }
        
        if deadline < Date() {
            return .cancelled
        }
        
        return .active
    }
}
enum CampaignStatus: String, Codable {
    case draft
    case active
    case completed
    case cancelled
}


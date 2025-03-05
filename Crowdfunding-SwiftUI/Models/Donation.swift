import Foundation

struct Donation: Identifiable, Codable {
    let id: Int
    let campaignId: Int
    let donor: String
    let amount: Double
    let donationDate: Date
}

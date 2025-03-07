// Donation Request model
struct DonationRequest: Codable {
    let campaignId: Int
    let donor: String
    let amount: Double
}

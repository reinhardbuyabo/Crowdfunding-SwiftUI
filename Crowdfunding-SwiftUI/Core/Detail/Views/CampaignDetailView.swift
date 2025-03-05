import SwiftUI

struct CampaignDetailView: View {
    let campaign: Campaign
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(campaign.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(campaign.description)
                    .font(.body)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Goal")
                        Text("$\(campaign.target, specifier: "%.2f")")
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Current Funds")
                        Text("$\(campaign.amountCollected, specifier: "%.2f")")
                            .fontWeight(.bold)
                    }
                }
                
                Text("Status: \(campaign.status.rawValue.capitalized)")
                    .foregroundColor(statusColor)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Campaign Details")
    }
    
    private var statusColor: Color {
        switch campaign.status {
        case .active: return .green
        case .completed: return .blue
        case .draft: return .gray
        case .cancelled: return .red
        }
    }
}

#Preview {
    let dateFormatter = ISO8601DateFormatter()
    let deadlineDate = dateFormatter.date(from: "2024-12-31T23:59:59Z")!
    
    return CampaignDetailView(campaign: Campaign(
        id: 1,
        owner: "0x1234567890abcdef",
        title: "Community Playground",
        description: "Building a new playground for local children",
        target: 50000,
        deadline: deadlineDate,
        amountCollected: 0,
        image: "https://example.com/playground.jpg"
    ))
}

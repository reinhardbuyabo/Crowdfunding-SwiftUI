import SwiftUI

struct CampaignsView: View {
    @StateObject private var viewModel = CampaignsViewModel()
    @State private var showCreateCampaign = false
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    ForEach(viewModel.campaigns) { campaign in
                        NavigationLink(destination: CampaignDetailView(campaign: campaign)) {
                            CampaignRowView(campaign: campaign)
                        }
                    }
                }
            }
            .navigationTitle("Campaigns")
            .navigationBarItems(trailing:
                Button(action: { showCreateCampaign = true }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showCreateCampaign) {
                CreateCampaignsView(viewModel: viewModel)
            }
        }
    }
}

struct CampaignRowView: View {
    let campaign: Campaign
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(campaign.title)
                .font(.headline)
            Text(campaign.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack {
                Text("Goal: Ksh \(campaign.target, specifier: "%.2f")")
                Spacer()
                Text(campaign.status.rawValue.capitalized)
                    .foregroundColor(statusColor)
            }
        }
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
    CampaignsView()
}

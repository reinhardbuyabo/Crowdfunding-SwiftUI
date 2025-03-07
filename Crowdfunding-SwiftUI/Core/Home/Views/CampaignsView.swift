import SwiftUI

struct CampaignsView: View {
    @StateObject private var viewModel = CampaignsViewModel()
    @State private var showingCreateCampaign = false
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else if viewModel.campaigns.isEmpty {
                    Text("No campaigns found")
                } else {
                    ForEach(viewModel.campaigns) { campaign in
                        NavigationLink(destination: CampaignDetailView(campaign: campaign)) {
                            VStack(alignment: .leading) {
                                Text(campaign.title)
                                    .font(.headline)
                                Text("Target: Ksh \(campaign.target, specifier: "%.2f")")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Campaigns")
            .navigationBarItems(trailing:
                Button(action: { showingCreateCampaign = true }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingCreateCampaign) {
                CreateCampaignView(viewModel: viewModel)
            }
        }
    }
}

struct CampaignsView_Previews: PreviewProvider {
    static var previews: some View {
        CampaignsView()
    }
}


///
///
///
///
///// Campaigns View
//struct CampaignsView: View {
//var body: some View {
//NavigationView {
//Text("Campaigns will be listed here")
//.navigationTitle("Campaigns")
//}
//}
//}

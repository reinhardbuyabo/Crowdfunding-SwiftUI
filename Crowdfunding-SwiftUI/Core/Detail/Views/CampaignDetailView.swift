// Campaign Detail View
import SwiftUI

struct CampaignDetailView: View {
    let campaign: Campaign
    @State private var donationAmount: String = ""
    @StateObject private var viewModel = CampaignDetailViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text(campaign.title)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            AsyncImage(url: URL(string: campaign.image)) { image in
                image.resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text("Target: Ksh \(campaign.target, specifier: "%.2f")")
                .font(.headline)
            Text("Amount Collected: Ksh \(viewModel.campaign?.amountCollected ?? campaign.amountCollected, specifier: "%.2f")")
                .font(.headline)
            Text("Deadline: \(campaign.deadline, style: .date)")
                .font(.headline)
            
            Text(campaign.description)
                .font(.body)
                .padding()
            
            TextField("Enter amount to donate", text: $donationAmount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding()
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: {
                    if let amount = Double(donationAmount) {
                        viewModel.donateToCampaign(amount: amount, campaign: campaign)
                    }
                }) {
                    Text("Donate Now")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .padding()
            .alert(isPresented: $viewModel.showSuccessMessage) {
                Alert(
                    title: Text("Donation Successful"),
                    message: Text("You donated Ksh\(viewModel.donationAmount!, specifier: "%.2f") successfully!"),
                    dismissButton: .default(Text("OK")) {
                        viewModel.updateCampaignAmountCollected()
                        viewModel.navigateToCampaigns()
                    }
                )
            }
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// CampaignDetailView Preview
#Preview {
    CampaignDetailView(campaign: .init(id: 1, owner: "", title: "", description: "", target: 0, deadline: Date(), amountCollected: 0, image: ""))
}

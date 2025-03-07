/// Campaign Detail View Model
import Foundation
import Combine

class CampaignDetailViewModel: ObservableObject {
    @Published var campaign: Campaign?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showSuccessMessage = false
    @Published var donationAmount: Double?
    
    private var cancellables = Set<AnyCancellable>()
    private let campaignDataService: CampaignDataService
    
    init(campaignDataService: CampaignDataService = .shared) {
        self.campaignDataService = campaignDataService
    }
    
//    func donateToCampaign(amount: Double, campaign: Campaign) {
//        isLoading = true
//        campaignDataService.donateToCampaign(amount: amount, campaign: campaign)
//            .sink(receiveCompletion: { completion in
//                self.isLoading = false
//                if case .failure(let error) = completion {
//                    self.errorMessage = error.localizedDescription
//                }
//            }, receiveValue: { response in
//                self.donationAmount = response.donation.amount
//                self.showSuccessMessage = true
//                self.campaign?.amountCollected += response.donation.amount
//            })
//            .store(in: &cancellables)
//    }
    
    func donateToCampaign(amount: Double, campaign: Campaign) {
        isLoading = true
        campaignDataService.donateToCampaign(amount: amount, campaign: campaign)
            .sink(receiveCompletion: { completion in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    self.donationAmount = response.donation.amount
                    self.showSuccessMessage = true
                    if self.campaign == nil {
                        self.campaign = campaign
                    }
                    self.campaign?.amountCollected += response.donation.amount
                    self.objectWillChange.send()  // Force UI update
                }
            })
            .store(in: &cancellables)
    }

    
    func updateCampaignAmountCollected() {
        if let donationAmount = self.donationAmount {
            self.campaign?.amountCollected += donationAmount
        }
    }
    
    func navigateToCampaigns() {
        // Logic to navigate back to the campaigns page
    }
}

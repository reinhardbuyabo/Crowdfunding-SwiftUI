
// ProfileViewModel.swift
import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userCampaigns: [Campaign] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let campaignDataService: CampaignDataService
    
    init(campaignDataService: CampaignDataService = .shared) {
        self.campaignDataService = campaignDataService
        fetchUserCampaigns()
    }
    
    func fetchUserCampaigns() {
        isLoading = true
        campaignDataService.fetchCampaigns()
            .map { campaigns in
                campaigns.filter { $0.owner == "currentUser" } // Replace with actual user identification
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
                self.isLoading = false
            }, receiveValue: { [weak self] campaigns in
                self?.userCampaigns = campaigns
            })
            .store(in: &cancellables)
    }
}

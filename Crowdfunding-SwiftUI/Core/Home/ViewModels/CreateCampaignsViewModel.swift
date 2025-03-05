import Foundation
import Combine

class CreateCampaignsViewModel: ObservableObject {
    @Published var campaigns: [Campaign] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    private let campaignDataService: CampaignDataService
    
    init(campaignDataService: CampaignDataService = .shared) {
        self.campaignDataService = campaignDataService
    }
    
    func fetchCampaigns() {
        isLoading = true
        campaignDataService.fetchCampaigns()
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: { [weak self] fetchedCampaigns in
                self?.campaigns = fetchedCampaigns
            }
            .store(in: &cancellables)
    }
    
    func createCampaign(request: CreateCampaignRequest) {
        isLoading = true
        campaignDataService.createCampaign(request: request)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: { [weak self] newCampaign in
                self?.campaigns.append(newCampaign)
            }
            .store(in: &cancellables)
    }
}

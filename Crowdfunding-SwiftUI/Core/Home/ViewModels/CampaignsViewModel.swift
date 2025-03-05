import Foundation
import Combine

class CampaignsViewModel: ObservableObject {
    @Published var campaigns: [Campaign] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchCampaigns()
    }
    
    func fetchCampaigns() {
        isLoading = true
        errorMessage = nil
        
        CampaignDataService.shared.fetchCampaigns()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] fetchedCampaigns in
                self?.campaigns = fetchedCampaigns
            }
            .store(in: &cancellables)
    }
    
    func createCampaign(
        owner: String,
        title: String,
        description: String,
        target: Double,
        deadline: Date,
        image: String? = nil
    ) {
        let request = CreateCampaignRequest(
            owner: owner,
            title: title,
            description: description,
            target: target,
            deadline: deadline,
            image: image,
            amountCollected: 0
        )
        
        isLoading = true
        errorMessage = nil
        
        CampaignDataService.shared.createCampaign(request: request)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] newCampaign in
                self?.campaigns.append(newCampaign)
            }
            .store(in: &cancellables)
    }
}

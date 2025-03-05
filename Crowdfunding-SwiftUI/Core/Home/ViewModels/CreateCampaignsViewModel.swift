import Foundation
import SwiftUI

class CreateCampaignViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var target: Double = 0
    @Published var deadline = Date()
    @Published var image: URL?
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var campaignCreated = false
    
    private let networkManager = NetworkManager() // Assuming you have a NetworkManager
    
    func createCampaign() {
        guard validate() else { return }
        
        isLoading = true
        errorMessage = nil
        
        let campaignData = Campaign(
            id: 0, // Backend will assign actual ID
            owner: "current_user_address", // Replace with actual user address
            title: title,
            description: description,
            target: target,
            deadline: deadline,
            amountCollected: 0,
            image: image?.absoluteString ?? ""
        )
        
        networkManager.createCampaign(campaign: campaignData) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    self?.campaignCreated = true
                    self?.resetForm()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func validate() -> Bool {
        // Add your validation logic
        guard !title.isEmpty else {
            errorMessage = "Title cannot be empty"
            return false
        }
        
        guard target > 0 else {
            errorMessage = "Target must be greater than zero"
            return false
        }
        
        guard deadline > Date() else {
            errorMessage = "Deadline must be in the future"
            return false
        }
        
        return true
    }
    
    private func resetForm() {
        title = ""
        description = ""
        target = 0
        deadline = Date()
        image = nil
    }
}

import Foundation
import Combine

class CampaignDataService {
    static let shared = CampaignDataService()
    
    private let baseURL = URL(string: "http://localhost:8080/api/")!
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    private init() {
        jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        
        jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
    }
    
    func fetchCampaigns() -> AnyPublisher<[Campaign], Error> {
        let url = baseURL.appendingPathComponent("campaigns")
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Campaign].self, decoder: jsonDecoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func createCampaign(request: CreateCampaignRequest) -> AnyPublisher<Campaign, Error> {
        let url = baseURL.appendingPathComponent("campaigns")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try jsonEncoder.encode(request)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Campaign.self, decoder: jsonDecoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func donateToCampaign(amount: Double, campaign: Campaign) -> AnyPublisher<DonationResponse, Error> {
        let url = baseURL.appendingPathComponent("campaigns/\(campaign.id)/donate")
        
        let payload: [String: Any] = [
            "campaignId": campaign.id,
            "donor": "Ada Lovelace", // Replace with actual donor name from user input
            "amount": amount
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode request data"]))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let jsonDecoder: JSONDecoder = {
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            return decoder
        }()
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: DonationResponse.self, decoder: jsonDecoder) // Use default decoder
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}


//
//  HomeAPIClient.swift
//  Santander
//
//  Created by Robson Moreira on 14/07/23.
//

import Foundation
import Combine

protocol HomeAPIClientProtocol {
    func fetchHome(from userId: Int) -> AnyPublisher<Home, Error>
}

final class HomeAPIClient: HomeAPIClientProtocol {
    
    private let urlSession = URLSession.shared
    
    func fetchHome(from userId: Int) -> AnyPublisher<Home, Error> {
        guard let url = UserRouter.users(id: String(userId)).asUrl() else {
            fatalError()
        }
        return urlSession.dataTaskPublisher(for: url)
            .tryDecodeResponse(type: HomeResponse.self, decoder: JSONDecoder())
            .map { $0.toHome() }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

fileprivate struct API {
    static let dioBaseUrl = "https://digitalinnovationone.github.io/santander-dev-week-2023-api"
    static let mocks = "/mocks/find_one.json"
    
    static let baseUrl = "https://sdw-2023-prd.up.railway.app"
    static let users = "/users"
}

fileprivate enum UserRouter {
    
    case mocks
    case users(id: String)
    
    var path: String {
        switch self {
        case .mocks: return API.mocks
        case .users: return API.users
        }
    }
    
    func asUrl() -> URL? {
        switch self {
        case .mocks:
            guard let url = URL(string: API.dioBaseUrl) else { return nil }
            let urlRequest = URLRequest(url: url.appendingPathComponent(path))
            return urlRequest.url
        case .users(let id):
            guard let url = URL(string: API.baseUrl) else { return nil }
            let urlRequest = URLRequest(url: url.appendingPathComponent(path).appendingPathComponent(id))
            return urlRequest.url
        }
    }
}

// MARK: - HomeResponse
fileprivate struct HomeResponse: Decodable {
    
    let id: Int
    let name: String
    let account: AccountResponse
    let card: CardResponse
    let features: [FeatureResponse]
    let news: [FeatureResponse]
    
    func toHome() -> Home {
        Home(
            name: name,
            account: account.toAccount(),
            card: card.toCard(),
            features: features.map { $0.toFeature() },
            news: news.map { $0.toNews() }
        )
    }
}

// MARK: - Account
fileprivate struct AccountResponse: Decodable {
    
    let id: Int
    let number: String
    let agency: String
    let balance: Double
    let limit: Double
    
    func toAccount() -> Account {
        Account(
            number: number,
            agency: agency,
            balance: balance,
            limit: limit
        )
    }
}

// MARK: - Card
fileprivate struct CardResponse: Decodable {
    
    let id: Int
    let number: String
    let limit: Double
    
    func toCard() -> Card {
        Card(number: number, limit: limit)
    }
}

// MARK: - Feature
fileprivate struct FeatureResponse: Decodable {
    
    let id: Int
    let icon: String
    let description: String
    
    func toFeature() -> Feature {
        Feature(id: id, iconUrl: icon, description: description)
    }
    
    func toNews() -> News {
        News(id: id, iconUrl: icon, description: description)
    }
}

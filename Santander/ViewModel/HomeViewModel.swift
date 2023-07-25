//
//  HomeViewModel.swift
//  Santander
//
//  Created by Robson Moreira on 17/07/23.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    
    enum State {
        case idle
        case loading
        case failed(String)
        case loaded
    }
    
    private(set) var accountViewModel = AccountViewModel()
    private(set) var balanceViewModel = BalanceViewModel()
    private(set) var featureViewModel = FeatureViewModel()
    private(set) var cardViewModel = CardViewModel()
    private(set) var newsViewModel = NewsViewModel()
    
    private let homeApiClient: HomeAPIClientProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    @Published private(set) var state = State.idle
    
    // MARK: -
    
    init(homeApiClient: HomeAPIClientProtocol = HomeAPIClient()) {
        self.homeApiClient = homeApiClient
        setupViewModels()
    }
    
    private func setupViewModels() {}
    
    // MARK: - Home
    
    func fetchHome() {
        homeApiClient.fetchHome(from: 1)
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.state = .loading
            }, receiveCompletion: { [weak self] in
                switch $0 {
                case .finished:
                    self?.state = .loaded
                case .failure(let err):
                    self?.handleError(err)
                }
            })
            .sink(receiveCompletion: { [weak self] in
                if case .failure(let err) = $0 {
                  self?.handleError(err)
                }
            }, receiveValue: { [weak self] home in
                self?.accountViewModel.do {
                    $0.name = home.name
                    $0.agency = home.account.agency
                    $0.account = home.account.number
                }
                
                self?.balanceViewModel.do {
                    $0.balance = home.account.balance
                    $0.limit = home.account.limit
                }
                
                self?.featureViewModel.do {
                    $0.features = home.features
                }
                
                self?.cardViewModel.do {
                    $0.card = home.card
                }
                
                self?.newsViewModel.do {
                    $0.news = home.news
                }
            }).store(in: &subscriptions)
    }
    
    private func handleError(_ error: Error) {
        let errorDescription: String = {
            switch error {
            case is URLError:
                return "Ocorreu um erro ao tentar carregar os dados da Home."
            case is DecodingError:
                return "Ocorreu um erro ao converter os dados."
            default:
                return "Ocorreu um erro."
            }
        }()
        self.state = .failed(errorDescription)
    }
    
}

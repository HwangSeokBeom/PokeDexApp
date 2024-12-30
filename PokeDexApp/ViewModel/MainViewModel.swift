import Foundation
import RxSwift
import Moya
import RxMoya

class MainViewModel {
    /// DisposeBag for managing subscriptions
    private let disposeBag = DisposeBag()
    
    /// BehaviorSubject for the View to observe
    let pokemonDataSubject = BehaviorSubject<[Pokemon]>(value: [])
    
    /// Fetches the Pokemon data from the API
    func fetchPokemonData() {
        // Fixed limit and offset values
        let limit = 20
        let offset = 0
        let endpoint = "pokemon?limit=\(limit)&offset=\(offset)"
        
        // Use NetworkManager to fetch data
        NetworkManager.shared.fetch(endpoint: endpoint)
            .subscribe(onSuccess: { [weak self] (pokemonResponse: PokemonResponse) in
                // On success, pass the data to the BehaviorSubject
                self?.pokemonDataSubject.onNext(pokemonResponse.results)
            }, onFailure: { [weak self] error in
                // On failure, pass the error to the BehaviorSubject
                self?.pokemonDataSubject.onError(error)
            }).disposed(by: disposeBag)
    }
}

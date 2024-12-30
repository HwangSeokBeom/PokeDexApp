import Foundation
import RxSwift

class MainViewModel {

    private let disposeBag = DisposeBag()
    
    let pokemonDataSubject = BehaviorSubject<[Pokemon]>(value: [])
    
    let pokemonDetailSubject = BehaviorSubject<PokeMonDetail?>(value: nil)
    
    func fetchPokemonData() {
        let limit = 20
        let offset = 0
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            pokemonDataSubject.onError(NetworkError.invalidUrl)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (pokemonResponse: PokemonResponse) in
                self?.pokemonDataSubject.onNext(pokemonResponse.results)
            }, onFailure: { [weak self] error in
                self?.pokemonDataSubject.onError(error)
            }).disposed(by: disposeBag)
    }
    
    func fetchPokemonDetail(for urlString: String) {
        guard let url = URL(string: urlString) else {
            pokemonDetailSubject.onError(NetworkError.invalidUrl)
            return
        }
    
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (pokemonDetail: PokeMonDetail) in
                self?.pokemonDetailSubject.onNext(pokemonDetail)
            }, onFailure: { [weak self] error in
                self?.pokemonDetailSubject.onError(error)
            }).disposed(by: disposeBag)
    }
}

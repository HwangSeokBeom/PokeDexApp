import Foundation
import RxSwift
import UIKit

final class MainViewControllerModel { // 지금 여기 있는 것들을 NetworkManger와 MainViewModel 사이에 있는 useCase 객체를 만들어서 옮기기

    private let disposeBag = DisposeBag()
    let pokemonListSubject = BehaviorSubject<[Pokemon]>(value: [])
    private var currentPage = 0
    private let limit = 20
    private var isLoading = false  // 로딩 중 상태 추가
    
    func fetchPokemonData() {
        guard !isLoading else { return } // 이미 로딩 중이면 요청하지 않음
        isLoading = true
        
        let offset = currentPage * limit
        
        guard let url = APIEndpoint.pokemonListURL(limit: limit, offset: offset) else {
            pokemonListSubject.onError(NetworkError.invalidUrl)
            isLoading = false
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (pokemonResponse: PokemonResponse) in
                guard let self = self else { return }
                
                do {
                    // 새로운 데이터가 로드되면 기존 데이터에 추가
                    self.currentPage += 1
                    var currentPokemonList = try self.pokemonListSubject.value()

                    // 중복된 데이터를 추가하지 않도록 필터링
                    let newPokemons = pokemonResponse.results.filter { newPokemon in
                        !currentPokemonList.contains { $0.url == newPokemon.url }
                    }
                    
                    currentPokemonList.append(contentsOf: newPokemons)
                    self.pokemonListSubject.onNext(currentPokemonList)
                    
                    self.isLoading = false
                } catch {
                    print("Error fetching Pokémon list: \(error)")
                    self.isLoading = false
                }
            }, onFailure: { [weak self] error in
                self?.pokemonListSubject.onError(error)
                self?.isLoading = false
            }).disposed(by: disposeBag)
    }
    
}

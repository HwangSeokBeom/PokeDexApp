import RxSwift
import RxCocoa
import UIKit

import RxSwift
import RxCocoa
import UIKit

final class MainViewModel {
    
    private let disposeBag = DisposeBag()
    private let useCase: PokemonListUseCaseProtocol
    
    let pokemonListSubject = BehaviorSubject<[Pokemon]>(value: [])
    let pokemonImagesSubject = BehaviorSubject<[Int: UIImage?]>(value: [:])
    let pokemonSelected = PublishSubject<Pokemon>()
    
    private var currentPage = 0
    private let limit = 20
    private var isLoading = false
    
    init(useCase: PokemonListUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetchPokemonData() {
        guard !isLoading else { return }
        isLoading = true
        
        let offset = currentPage * limit
        useCase.fetchPokemonList(limit: limit, offset: offset)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                
                self.currentPage += 1
                var currentList = (try? self.pokemonListSubject.value()) ?? []
                
                let newPokemons = response.results
                currentList.append(contentsOf: newPokemons)
                self.pokemonListSubject.onNext(currentList)
           
                newPokemons.forEach { pokemon in
                    if let id = pokemon.id {
                        self.fetchPokemonImage(for: id)
                    }
                }
                
                self.isLoading = false
            }, onFailure: { [weak self] error in
                self?.pokemonListSubject.onError(error)
                self?.isLoading = false
            }).disposed(by: disposeBag)
    }
    
    private func fetchPokemonImage(for id: Int) {
        useCase.fetchPokemonImage(for: id)
            .subscribe(onSuccess: { [weak self] image in
                guard let self = self else { return }
                var currentImages = (try? self.pokemonImagesSubject.value()) ?? [:]
                currentImages[id] = image
                self.pokemonImagesSubject.onNext(currentImages)
            }, onFailure: { [weak self] _ in
                guard let self = self else { return }
                var currentImages = (try? self.pokemonImagesSubject.value()) ?? [:]
                currentImages[id] = nil
                self.pokemonImagesSubject.onNext(currentImages)
            }).disposed(by: disposeBag)
    }
}


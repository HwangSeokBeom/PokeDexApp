//
//  Untitled.swift
//  PokeDexApp
//
//  Created by 황석범 on 1/3/25.
//
import RxSwift
import UIKit

final class PokemonUseCase: PokemonListUseCaseProtocol, PokemonDetailUseCaseProtocol {
    
    private let networkManager: NetworkManager
    private let disposeBag = DisposeBag()
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    func fetchPokemonList(limit: Int, offset: Int) -> Single<PokemonResponse> {
        guard let url = APIEndpoint.pokemonListURL(limit: limit, offset: offset) else {
            return .error(NetworkError.invalidUrl)
        }
        return networkManager.fetch(url: url)
    }
    
    func fetchPokemonDetail(for urlString: String) -> Single<PokemonDetail> {
        guard let url = APIEndpoint.pokemonDetailURL(for: urlString) else {
            return .error(NetworkError.invalidUrl)
        }
        return networkManager.fetch(url: url)
    }
    
    func fetchPokemonImage(for id: Int) -> Single<UIImage> {
        return networkManager.fetchPokemonImage(for: id)
    }
}

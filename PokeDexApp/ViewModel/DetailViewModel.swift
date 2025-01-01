//
//  Untitled.swift
//  PokeDexApp
//
//  Created by 내일배움캠프 on 12/31/24.
//

import Foundation
import RxSwift
import UIKit

final class DetailViewModel {
    
    private let disposeBag = DisposeBag()
    let pokemonDetailSubject = BehaviorSubject<PokemonDetail?>(value: nil)
    let pokemonImageSubject = BehaviorSubject<UIImage?>(value: nil)
    
    func fetchPokemonDetail(for urlString: String) {
        guard let url = APIEndpoint.pokemonDetailURL(for: urlString) else {
            pokemonDetailSubject.onError(NetworkError.invalidUrl)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (pokemonDetail: PokemonDetail) in
                self?.pokemonDetailSubject.onNext(pokemonDetail)
                self?.fetchPokemonImage(for: pokemonDetail.id)
            }, onFailure: { [weak self] error in
                self?.pokemonDetailSubject.onError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchPokemonImage(for id: Int) {
        NetworkManager.shared.fetchPokemonImage(for: id)
            .subscribe(onSuccess: { [weak self] image in
                self?.pokemonImageSubject.onNext(image)
            }, onFailure: { [weak self] error in
                self?.pokemonImageSubject.onError(error)
            })
            .disposed(by: disposeBag)
    }
}

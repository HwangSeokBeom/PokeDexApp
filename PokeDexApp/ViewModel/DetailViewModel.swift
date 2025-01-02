//
//  Untitled.swift
//  PokeDexApp
//
//  Created by 내일배움캠프 on 12/31/24.
//

import Foundation
import RxSwift
import UIKit
import RxCocoa

final class DetailViewModel {
    
    private let disposeBag = DisposeBag()
    let pokemonDetailSubject = BehaviorSubject<PokemonDetail?>(value: nil)
    let pokemonImageRelay = PublishRelay<UIImage?>()
    
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
                self?.pokemonImageRelay.accept(image) 
            }, onFailure: { [weak self] error in
                self?.pokemonImageRelay.accept(nil)
            })
            .disposed(by: disposeBag)
    }
}

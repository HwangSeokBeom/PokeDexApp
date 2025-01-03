//
//  Untitled.swift
//  PokeDexApp
//
//  Created by 내일배움캠프 on 12/31/24.
//

import RxSwift
import UIKit
import RxCocoa

final class DetailViewModel {
    
    private let disposeBag = DisposeBag()
    private let useCase: PokemonUseCase
    let pokemonDetailSubject = BehaviorSubject<PokemonDetail?>(value: nil)
    let pokemonImageRelay = PublishRelay<UIImage?>()
    
    init(useCase: PokemonUseCase) {
        self.useCase = useCase
    }
    
    func fetchPokemonDetail(for urlStirng: String) {
        useCase.fetchPokemonDetail(for: urlStirng)
            .subscribe(onSuccess: { [weak self] detail in
                self?.pokemonDetailSubject.onNext(detail)
                self?.fetchPokemonImage(for: detail.id)
            }, onFailure: { [weak self] error in
                self?.pokemonDetailSubject.onError(error)
            }).disposed(by: disposeBag)
    }
    
    func fetchPokemonImage(for id: Int) {
        useCase.fetchPokemonImage(for: id)
            .subscribe(onSuccess: { [weak self] image in
                self?.pokemonImageRelay.accept(image)
            }, onFailure: { [weak self] _ in
                self?.pokemonImageRelay.accept(nil)
            }).disposed(by: disposeBag)
    }
}


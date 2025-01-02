import Foundation
import RxSwift
import UIKit
import RxCocoa

final class MainViewCellModel {
    private let disposeBag = DisposeBag()
    let pokemonImageRelay = PublishRelay<UIImage?>()
   
    func fetchPokemonImage(for id: Int) {
        NetworkManager.shared.fetchPokemonImage(for: id)
            .subscribe(onSuccess: { [weak self] image in
                self?.pokemonImageRelay.accept(image) // 값 방출
            }, onFailure: { [weak self] error in
                self?.pokemonImageRelay.accept(nil) // 실패 시 nil 방출 (필요에 따라)
            })
            .disposed(by: disposeBag)
    }
}

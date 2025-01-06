//
//  Untitled.swift
//  PokeDexApp
//
//  Created by 황석범 on 1/6/25.
//

import UIKit
import RxSwift

final class AppCoordinator {
    private let navigationController: UINavigationController
    private let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let useCase = PokemonUseCase()
        let mainViewModel = MainViewModel(useCase: useCase)
        let mainVC = MainViewController(viewModel: mainViewModel, coordinator: self)
        
        mainViewModel.pokemonSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] selectedPokemon in
                self?.navigateToDetail(with: selectedPokemon)
            })
            .disposed(by: disposeBag)
        
        navigationController.setViewControllers([mainVC], animated: false)
    }
    
    func navigateToDetail(with pokemon: Pokemon) {
        let useCase = PokemonUseCase()
        let detailViewModel = DetailViewModel(useCase: useCase)
        detailViewModel.fetchPokemonDetail(for: pokemon.url) // 데이터 초기화
        
        let detailVC = DetailViewController(viewModel: detailViewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
}


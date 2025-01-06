//
//  Untitled.swift
//  PokeDexApp
//
//  Created by 황석범 on 1/6/25.
//

import UIKit

final class AppCoordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let useCase = PokemonUseCase()
        let mainViewModel = MainViewControllerModel(useCase: useCase)
        let mainVC = MainViewController(viewModel: mainViewModel, coordinator: self)
        navigationController.setViewControllers([mainVC], animated: false)
    }
    
    func navigateToDetail(with pokemon: Pokemon) {
        let url = pokemon.url 
        let useCase = PokemonUseCase()
        let detailViewModel = DetailViewModel(useCase: useCase)
        detailViewModel.fetchPokemonDetail(for: url)
        let detailVC = DetailViewController(viewModel: detailViewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
}

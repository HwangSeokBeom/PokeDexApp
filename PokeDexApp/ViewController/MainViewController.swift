//
//  ViewController.swift
//  PokeDexApp
//
//  Created by 내일배움캠프 on 12/27/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class MainViewController: UIViewController {
    
    private var mainView = MainView()
    private let viewModel = MainViewControllerModel()
    private let disposeBag = DisposeBag()
    private var pokemon: [Pokemon] = []
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchPokemonData() // 초기 데이터 로드
        bind()
    }
    
    private func bind() {
        viewModel.pokemonListSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pokemon in
                self?.pokemon = pokemon
                self?.mainView.collectionView.reloadData()
            }, onError: { error in
                print("Error fetching Pokémon data: \(error)")
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    // 스크롤 시 추가 데이터를 미리 요청
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        let height = scrollView.frame.size.height
        
        // 스크롤이 거의 끝에 도달하면 데이터 요청
        if scrollOffset + height > contentHeight - 100 {
            loadMoreData()
        }
    }
    
    // 더 많은 데이터 요청
    private func loadMoreData() {
        viewModel.fetchPokemonData() // 더 많은 데이터 요청
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCell.identifier, for: indexPath) as? MainViewCell else {
            return UICollectionViewCell()
        }
        
        let currentPokemon = pokemon[indexPath.row]
        cell.configure(with: currentPokemon, indexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPokemon = pokemon[indexPath.row]
        let detailViewModel = DetailViewModel()
        detailViewModel.fetchPokemonDetail(for: selectedPokemon.url)
        let detailVC = DetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}




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
    
    private let viewModel: MainViewModel
    private let disposeBag = DisposeBag()
    private var pokemon: [Pokemon] = []
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "pokemonBall")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.frame.width - 30) / 3, height: 120)
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: MainViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.backgroundColor = .darkRed
        
        return collectionView
    }()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchPokemonData() // 초기 데이터 로드
        bind()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .mainRed
        [imageView, collectionView].forEach{ view.addSubview($0)}
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalTo(view)
            make.width.height.equalTo(100)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func bind() {
        viewModel.pokemonListSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pokemon in
                self?.pokemon = pokemon
                self?.collectionView.reloadData()
            }, onError: { error in
                print("Error fetching Pokémon data: \(error)")
            })
            .disposed(by: disposeBag)
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




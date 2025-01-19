import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class MainViewController: UIViewController {
    
    private var mainView = MainView()
    private let viewModel: MainViewModel
    private let coordinator: AppCoordinator
    private let disposeBag = DisposeBag()
    private var pokemon: [Pokemon] = []
    
    init(viewModel: MainViewModel, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        self.rx.viewDidLoad
            .bind(onNext: { [weak self] in
                self?.viewModel.fetchPokemonData()
            })
            .disposed(by: disposeBag)
        
        viewModel.pokemonListSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pokemon in
                self?.pokemon = pokemon
                self?.mainView.collectionView.reloadData()
            }, onError: { error in
                print("Error fetching Pokémon data: \(error)")
            })
            .disposed(by: disposeBag)
        
        viewModel.pokemonImagesSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] images in
                self?.mainView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.contentOffset
            .map { [weak self] offset -> Bool in
                guard let self = self else { return false }
                let contentHeight = self.mainView.collectionView.contentSize.height
                let height = self.mainView.collectionView.frame.size.height
                return offset.y + height > contentHeight - 100
            }
            .distinctUntilChanged() // 중복 호출 방지
            .filter { $0 } // true인 경우만 통과
            .map { _ in () } // Void로 변환
            .bind(to: viewModel.loadMoreTrigger)
            .disposed(by: disposeBag)
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        let height = scrollView.frame.size.height
        
        if scrollOffset + height > contentHeight - 100 {
            loadMoreData()
        }
    }
    
    private func loadMoreData() {
        viewModel.fetchPokemonData()
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
        
        if let id = currentPokemon.id {
            let images = (try? viewModel.pokemonImagesSubject.value()) ?? [:]
            let image = images[id] ?? nil
            cell.setImage(image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPokemon = pokemon[indexPath.row]
        viewModel.pokemonSelected.onNext(selectedPokemon)
    }
}

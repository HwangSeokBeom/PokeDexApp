import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class MainViewController: UIViewController {
    
    private var mainView = MainView()
    private let viewModel: MainViewControllerModel
    private let disposeBag = DisposeBag()
    private var pokemon: [Pokemon] = []
    
    init(viewModel: MainViewControllerModel) {
        self.viewModel = viewModel
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
        viewModel.fetchPokemonData() // 초기 데이터 로드
        bind()
    }
    
    private func bind() {
        // 포켓몬 리스트 데이터 바인딩
        viewModel.pokemonListSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pokemon in
                self?.pokemon = pokemon
                self?.mainView.collectionView.reloadData()
            }, onError: { error in
                print("Error fetching Pokémon data: \(error)")
            })
            .disposed(by: disposeBag)
        
        // 포켓몬 이미지 데이터 바인딩
        viewModel.pokemonImagesSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] images in
                self?.mainView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        // 컬렉션 뷰 설정
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
        viewModel.fetchPokemonData() // 추가 데이터 요청
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
        let pokemonURL = selectedPokemon.url
        let detailUseCase = PokemonUseCase()
        let detailViewModel = DetailViewModel(useCase: detailUseCase)
        detailViewModel.fetchPokemonDetail(for: pokemonURL)
        let detailVC = DetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

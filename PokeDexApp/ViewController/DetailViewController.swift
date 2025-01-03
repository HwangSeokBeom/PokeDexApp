import UIKit
import RxSwift

final class DetailViewController: UIViewController {
    
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    private let detailView = DetailView()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        viewModel.pokemonDetailSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detail in
                guard let detail = detail else { return }
                
                if let formattedDetails = PokeDetailsFormatter(pokeDetails: detail) {
                    self?.detailView.nameLabel.text = formattedDetails.name
                    self?.detailView.typeLabel.text = formattedDetails.type
                    self?.detailView.heightLabel.text = formattedDetails.height
                    self?.detailView.weightLabel.text = formattedDetails.weight
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.pokemonImageRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.detailView.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
}

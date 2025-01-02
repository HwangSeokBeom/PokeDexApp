import UIKit
import RxSwift
import SnapKit
import Kingfisher

final class MainViewCell: UICollectionViewCell {
    
    static let identifier = "MainViewCell"
    private var currentIndexPath: IndexPath? // 현재 셀의 indexPath를 추적
    private let viewModel = MainViewCellModel() // 뷰모델 생성
    private let disposeBag = DisposeBag()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .cellBackground
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        // 뷰모델의 이미지 데이터를 구독
        viewModel.pokemonImageRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.currentIndexPath = nil
    }
    
    // 셀에 데이터 설정
    func configure(with pokemon: Pokemon, indexPath: IndexPath) {
        // 현재 셀의 indexPath를 저장
        self.currentIndexPath = indexPath
        
        // 현재 셀이 여전히 올바른 indexPath인지 확인
        guard self.currentIndexPath == indexPath else { return }
        
        // 포켓몬 이미지 로드 요청
        guard let id = pokemon.id else { return }
        viewModel.fetchPokemonImage(for: id)
    }
}

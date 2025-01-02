//
//  Untitled.swift
//  PokeDexApp
//
//  Created by 내일배움캠프 on 12/30/24.
//

import UIKit
import SnapKit
import RxSwift

final class MainViewCell: UICollectionViewCell {
    
    static let identifier = "MainViewCell"
    private let viewModel = MainViewCellModel()
    private var disposeBag = DisposeBag()
    private var currentIndexPath: IndexPath? // 현재 셀의 indexPath를 추적
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.disposeBag = DisposeBag()
        self.currentIndexPath = nil
        self.viewModel.pokemonImageRelay.accept(nil)
    }
    
    // 셀에 데이터 설정
    func configure(with pokemon: Pokemon, indexPath: IndexPath) {
        // 현재 셀의 indexPath를 저장
        self.currentIndexPath = indexPath
        
        // 현재 셀이 여전히 올바른 indexPath인지 확인
        guard self.currentIndexPath == indexPath else { return }
        
        guard let currentIndex = self.currentIndexPath?.row, currentIndex + 1 == pokemon.id else { return }
        
        guard let id = pokemon.id else { return }
        
        print( ">> \(currentIndex) >> \(id)")
        self.viewModel.fetchPokemonImage(for: id)
        
        // 포켓몬 이미지 구독
        self.viewModel.pokemonImageRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { image in
                // 현재 셀이 여전히 올바른 indexPath인지 확인
                guard self.currentIndexPath == indexPath else { return }
                
                self.imageView.image = image
                
            }, onError: { error in
                print("Error fetching image: \(error)")
            })
            .disposed(by: disposeBag)
    }

}

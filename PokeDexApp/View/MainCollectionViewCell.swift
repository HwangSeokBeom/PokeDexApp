//
//  Untitled.swift
//  PokeDexApp
//
//  Created by 내일배움캠프 on 12/30/24.
//

import UIKit
import SnapKit
import RxSwift

final class MainCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MainCollectionViewCell"
    private let viewModel = MainViewModel()
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
        self.disposeBag = DisposeBag() // 셀이 재사용되면 새로운 disposeBag을 할당
        self.currentIndexPath = nil // indexPath 초기화
    }
    
    // 셀에 데이터 설정
    func configure(with pokemon: Pokemon, indexPath: IndexPath) {
        // 현재 셀의 indexPath를 저장
        self.currentIndexPath = indexPath
        
        viewModel.fetchPokemonDetail(for: pokemon.url)
        
        viewModel.pokemonDetailSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pokemonDetail in
                guard let detail = pokemonDetail else { return }
                
                // 현재 셀의 indexPath와 일치하는지 확인
                if self?.currentIndexPath == indexPath {

                    self?.viewModel.fetchPokemonImage(for: detail.id)
                    
                    self?.viewModel.pokemonImageSubject
                        .observe(on: MainScheduler.instance)
                        .subscribe(onNext: { image in
                            DispatchQueue.main.async {
                                self?.imageView.image = image
                            }
                        }, onError: { error in
                            print("Error fetching image: \(error)")
                        })
                        .disposed(by: self?.disposeBag ?? DisposeBag()) //
                }
            }, onError: { error in
                print("Error fetching Pokémon detail: \(error)")
            })
            .disposed(by: disposeBag)
    }
}

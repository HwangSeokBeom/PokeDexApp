//
//  Untitled.swift
//  PokeDexApp
//
//  Created by 내일배움캠프 on 12/31/24.
//

import UIKit
import SnapKit
import RxSwift

final class DetailViewController: UIViewController {
    
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    
    private let detailView: UIView = {
        let detailView = UIView()
        detailView.layer.cornerRadius = 20
        detailView.backgroundColor = .darkRed
        return detailView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 40)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // 생성자에서 ViewModel 주입
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }
    
    private func setupViews() {
        view.backgroundColor = .mainRed
        [detailView, imageView, nameLabel, typeLabel, heightLabel, weightLabel].forEach { view.addSubview($0) }
        
        detailView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(detailView.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(detailView.snp.height).multipliedBy(0.5)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        heightLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(heightLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func bind() {
        viewModel.pokemonDetailSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detail in
                guard let detail = detail else { return }
                
                if let formattedDetails = PokeDetailsFormatter(pokeDetails: detail) {
                    self?.nameLabel.text = formattedDetails.name
                    self?.typeLabel.text = formattedDetails.type
                    self?.heightLabel.text = formattedDetails.height
                    self?.weightLabel.text = formattedDetails.weight
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.pokemonImageRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
}

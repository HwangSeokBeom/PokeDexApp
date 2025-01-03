//
//  Untitled.swift
//  PokeDexApp
//
//  Created by 황석범 on 1/3/25.
//

import UIKit
import SnapKit

final class DetailView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 40)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let heightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .darkRed
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .mainRed
        [containerView, imageView, nameLabel, typeLabel, heightLabel, weightLabel].forEach { addSubview($0) }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(containerView.snp.height).multipliedBy(0.5)
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
}

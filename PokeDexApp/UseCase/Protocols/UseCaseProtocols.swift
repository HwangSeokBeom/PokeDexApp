//
//  Untitled.swift
//  PokeDexApp
//
//  Created by 황석범 on 1/19/25.
//
import UIKit
import RxSwift

protocol PokemonListUseCaseProtocol {
    func fetchPokemonList(limit: Int, offset: Int) -> Single<PokemonResponse>
    func fetchPokemonImage(for id: Int) -> Single<UIImage>
}

protocol PokemonDetailUseCaseProtocol {
    func fetchPokemonDetail(for urlString: String) -> Single<PokemonDetail>
    func fetchPokemonImage(for id: Int) -> Single<UIImage>
}

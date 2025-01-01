//
//  Untitled.swift
//  PokeDexApp
//
//  Created by 내일배움캠프 on 12/31/24.
//

import Foundation

enum APIEndpoint {
    static let baseURL = "https://pokeapi.co/api/v2"
    static let imageBaseURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork"

    /// 포켓몬 데이터 리스트 URL 생성
    static func pokemonListURL(limit: Int, offset: Int) -> URL? {
        return URL(string: "\(baseURL)/pokemon?limit=\(limit)&offset=\(offset)")
    }

    /// 포켓몬 디테일 이미지 URL 생성
    static func pokemonImageURL(for id: Int) -> URL? {
        return URL(string: "\(imageBaseURL)/\(id).png")
    }

    /// 포켓몬 상세 데이터 URL 생성
    static func pokemonDetailURL(for urlString: String) -> URL? {
        return URL(string: urlString)
    }
}

//
//  Untitled.swift
//  PokeDexApp
//
//  Created by 내일배움캠프 on 12/30/24.
//

import Foundation

// 포켓몬 모델
struct Pokemon: Decodable {
    let name: String
    let url: String
}

// 포켓몬 리스트를 포함하는 응답 모델
struct PokemonResponse: Decodable {
    let results: [Pokemon]
}

struct PokeMonDetail: Decodable {
    let id: Int
    let name: String
    let types: [PokemonType]
    let height: Int
    let weight: Int
    let sprites: PokemonSprites
}

struct PokemonType: Decodable {
    let slot: Int
    let type: TypeDetail
}

struct TypeDetail: Decodable {
    let name: String
    let url: String
}

struct PokemonSprites: Decodable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

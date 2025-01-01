//
//  Untitled.swift
//  PokeDexApp
//
//  Created by 내일배움캠프 on 12/31/24.
//
import Foundation

struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    let types: [PokemonType]
    let height: Int
    let weight: Int
}

struct PokemonType: Decodable {
    let type: TypeDetail
}

struct TypeDetail: Decodable {
    let name: String
}

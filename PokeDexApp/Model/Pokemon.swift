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

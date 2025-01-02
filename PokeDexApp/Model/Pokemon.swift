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
    
    // URL에서 ID를 추출하는 계산 속성
    var id: Int? {
        return url.split(separator: "/").last.flatMap { Int($0) }
    }
}

// 포켓몬 리스트를 포함하는 응답 모델
struct PokemonResponse: Decodable {
    let results: [Pokemon]
}


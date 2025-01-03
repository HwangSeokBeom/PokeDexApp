//
//  Untitled.swift
//  PokeDexApp
//
//  Created by 내일배움캠프 on 12/30/24.
//

import Foundation

struct Pokemon: Decodable {
    let name: String
    let url: String
    
    var id: Int? {
        return url.split(separator: "/").last.flatMap { Int($0) }
    }
}

struct PokemonResponse: Decodable {
    let results: [Pokemon]
}


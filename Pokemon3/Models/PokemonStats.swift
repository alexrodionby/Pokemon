//
//  PokemonStats.swift
//  Pokemon3
//
//  Created by Alexandr Rodionov on 3.09.22.
//

// MARK: - Модель данных для экрана с подробностями о покемоне

import Foundation

/*
 URL: https://pokeapi.co/api/v2/pokemon/19/
 
 JSON Response:
 Too large to show here
 */

struct PokemonStats: Codable {
    let name: String?
    let height: Int?
    let weight: Int?
    let types: [TypeElement]?
    let sprites: Sprites?
    
    struct TypeElement: Codable {
        let slot: Int?
        let type: Species?
    }
    
    struct Species: Codable {
        let name: String?
        let url: String?
    }
    
    struct Sprites: Codable {
        let frontDefault: String?
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
}

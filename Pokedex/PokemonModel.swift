//
//  PokemonModel.swift
//  Pokedex
//
//  Created by John Chung on 7/24/17.
//  Copyright © 2017 John Chung. All rights reserved.
//

import Foundation

class PokemonModel {
    
    var name: String!
    var resourceURI: String!
    
    init(name: String, resourceURI: String) {
        self.name = name
        self.resourceURI = resourceURI
    }
    
}

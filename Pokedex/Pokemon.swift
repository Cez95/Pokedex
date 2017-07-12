//
//  Pokemon.swift
//  Pokedex
//
//  Created by Chris Olson on 7/12/17.
//  Copyright © 2017 Chris Olson. All rights reserved.
//

import Foundation

class Pokemon {
    private var _name: String!
    private var _pokeID: Int!
    
    
    var name: String {
        return _name
    }
    
    var pokeID: Int {
        return _pokeID
    }
    
    
    init(name: String, pokeID: Int){
        self._name = name
        self._pokeID = pokeID
        
    }
    
    
    
}

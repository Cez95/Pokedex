//
//  Pokemon.swift
//  Pokedex
//
//  Created by Chris Olson on 7/12/17.
//  Copyright © 2017 Chris Olson. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokeID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _weight: String!
    private var _height: String!
    private var _attack: String!
    private var _nextEvoTxt: String!
    private var _nextEvoName: String!
    private var _nextEvoID: String!
    private var _nextEvoLvl: String!
    private var _pokemonURL: String!
    
    var name: String {
        return _name
    }
    
    var pokeID: Int {
        return _pokeID
        
    }
    
    var nextEvoName: String {
        if _nextEvoName == nil {
           _nextEvoName = ""
        }
        return _nextEvoName
    }
    
    var nextEvoID: String {
        if _nextEvoID == nil {
            _nextEvoID = ""
        }
        return _nextEvoID
    }
    
    var nextEvoLvl: String {
        if _nextEvoLvl == nil {
            _nextEvoLvl =  ""
        }
        return _nextEvoLvl
    }
    
    
    var description: String {
        if _description == nil {
            _description = ""
        }
            
        return _description
        
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
        
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
        
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
        
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
        
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
        
    }
    
    var nextEvo: String {
        if _nextEvoTxt == nil {
            _nextEvoTxt = ""
        }
        return _nextEvoTxt
        
    }
    
    
    
    
    
    init(name: String, pokeID: Int){
        self._name = name
        self._pokeID = pokeID
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokeID)" // This function builds our API website that we call for data. pokeID is the variable response that correlates to each pokemon so that we we search the API returns its according JSON file
        
    }
    
    // This function loads the API data for each pokemon we have in our collection view
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonURL).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, Any> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                    print(self._weight)
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                    print(self._height)
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                    print(self._attack)
                    
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                    print(self._defense)
                }
                
                // This checks to see wether there are more than one type
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    // If only one name is present, this code will be called
                    if let name = types[0]["name"] {
                            self._type = name.capitalized
                        
                        }
                    // IF there are more than one names, It will loop through however many dictionarys there are and it will then add the new name onto the previous with a slash in the middle
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                        // If no name is contained, type will be set to an empty string
                        else {
                            self._type = ""
                    }
                    
                    // In this code block, we have another link to another JSON file that holds the description of each pokemon
                    if let descArr = dict["descriptions"] as? [Dictionary<String, String>], descArr.count > 0 { //This finds the key associated to value array that holds dictionarys
                        if let url = descArr[0]["resource_uri"] { //This goes into the array and in the first dictionary in the array it finds the key resource_uri which links to the page the pokemon description is on and saves it as url
                            
                            let descUrl = "\(URL_BASE)\(url)" // This builds the extension the page that holds the description for our pokemon is on
                            Alamofire.request(descUrl).responseJSON{ response in // A new alamofire request is needed because we are no on a new url
                                let result = response.result
                                if let dict = result.value as? Dictionary<String, Any> { // The new page is also a dictionary, we then search it for a description key and set the description value to the class variable
                                    if let description = dict["description"] as? String {
                                        self._description = description
                                        
                                    }
                                }
                               completed()
                            }
                            
                        }
                        
                        
 
                    }else {
                        self._description = ""
                    }
                    
                    // We now are searching for the evolution levels
                    if let evolutions =  dict["evolutions"] as? [Dictionary<String, Any>], evolutions.count > 0 { // Go into and arry with the the key of evolutions
                        
                        if let nextEvo = evolutions[0]["to"] as? String { // Check to see the value of the first dictionary in the arry has a key of "to"
                            // Because we dont suport mega pokemon, we are saying here that if the next evo isnt a mega, then we keep going in our search
                            if nextEvo.range(of: "mega") == nil {
                                self._nextEvoName = nextEvo
                                
                                if let uri = evolutions[0]["resource_uri"] as? String { // Next we go to find the ID. The ID is embeded inside of a key with a value of a uri so we save the uri as a constant uri
                                    let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "") // We extract the ID from the uri link
                                    let nextEvoID = newStr.replacingOccurrences(of: "/", with: "")
                                    
                                    self._nextEvoID = nextEvoID
                                
                                    if let lvlExist = evolutions[0]["level"] {
                                        
                                        if let lvl = lvlExist as? Int {
                                            self._nextEvoLvl = "\(lvl)"
                                        }
                                    } else {
                                        self._nextEvoLvl = ""
                                    }
                                }
                            }
                            print(self._nextEvoLvl)
                            print(self._nextEvoID)
                            print(self._nextEvoName)
                        }
                    }
                }
               
            }
             completed()
        }
        
    }
}


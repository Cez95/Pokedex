//
//  Constants.swift
//  Pokedex
//
//  Created by Chris Olson on 7/12/17.
//  Copyright © 2017 Chris Olson. All rights reserved.
//

import Foundation

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"

typealias DownloadComplete = () -> () // Creates a closure that is run at a later time. Will be passed to download pokemon details

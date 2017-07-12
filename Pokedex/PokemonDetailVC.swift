//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Chris Olson on 7/12/17.
//  Copyright © 2017 Chris Olson. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = pokemon.name
    }

 

}

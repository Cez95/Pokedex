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
    

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var evoLabel: UILabel!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var currentEvoImg: UIImageView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = self.pokemon.name.capitalized
        let img = UIImage(named: "\(self.pokemon.pokeID)")
        mainImage.image = img
        currentEvoImg.image = img
        pokedexLabel.text = "\(self.pokemon.pokeID)".capitalized
        
        
        pokemon.downloadPokemonDetails{
            // Whats written in this code block will  only run after the network call is complete!
           self.updateUI() // Cant update the data until it is actually garnered
            print(self.pokemon.description)
        }
    }
    
    
   

    func updateUI() {
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        attackLabel.text = pokemon.attack
        defenseLabel.text = pokemon.defense
        typeLabel.text = pokemon.type
        descriptionLabel.text = pokemon.description
        
        if pokemon.nextEvoID == "" {
            evoLabel.text = "No Evolutions"
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvoID)
            let str = "Next evolution: \(pokemon.nextEvoName) - LVL \(pokemon.nextEvoLvl)"
            evoLabel.text = str
        }
        
    }
  
    // Takes us back when button is pressed
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
 

}

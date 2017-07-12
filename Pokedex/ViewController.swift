//
//  ViewController.swift
//  Pokedex
//
//  Created by Chris Olson on 7/12/17.
//  Copyright © 2017 Chris Olson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Always used to instantiate the protocols
        collection.delegate = self
        collection.dataSource = self
    }

   
    
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // These are the set functions you need when you are going to have a collection view 
    
    // This function uses our base cell and recreates it for each new cell we have in our collection view. the identifier is "pokemonCell" and the data it recreates will come from the PokeCell view file
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokeCell", for: indexPath) as? PokeCell {
            
            // This populates the cell image with a new image for each cell
            let pokemon = Pokemon(name: "Pokemon", pokeID: indexPath.row)
            cell.configureCell(pokemon: pokemon)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    // This function executes code based on the cell we select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // This function determins how many cells we want to have in our collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    // This functions determines how many collectionviews we want to have
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // This sets the default size for each cell in the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    
    
    

}


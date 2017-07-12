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
    
    var pokemon = [Pokemon]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Always used to instantiate the protocols
        collection.delegate = self
        collection.dataSource = self
        
        parsePokemonCSV()
    }

   // This function works to prepare the CSV file in a format we can use to extract data. It places each pokemon stats into a dictionary
    func parsePokemonCSV() {
        // This links to the csv file that we are using. Its called "pokemon.csv"
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        // The do/catch runs the csv parser and if there is an error due to an NSError, the application wont crash as a result
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            // Rows are the dictionarys that hold the pokemon stats and we then iterate through each dictionary and pull out the two stats we need, name and pokeID
            for row in rows {
                // We save the stats we pull out as new constants
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]!
                
                // We then assign the new constants as paramenters for a new pokemon instance
                let poke = Pokemon(name: name, pokeID: pokeID)
                // We then append the new pokemon instance to the pokemon list defined above.
                pokemon.append(poke)
                // We loop through this 718 times for each pokemon
            }
        } catch let err  as NSError {
            
            print(err.debugDescription)
            
        }
    }
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // These are the set functions you need when you are going to have a collection view 
    
    // This function uses our base cell and recreates it for each new cell we have in our collection view. the identifier is "pokemonCell" and the data it recreates will come from the PokeCell view file
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokeCell", for: indexPath) as? PokeCell {
            
            // This populates the cell image with a new image for each cell
            let poke = pokemon[indexPath.row]
            cell.configureCell(poke)
            
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
        // Adds a new cell for each instance of pokemon that is in the pokemon array defined up top
        return pokemon.count
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


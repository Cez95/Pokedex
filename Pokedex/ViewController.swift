//
//  ViewController.swift
//  Pokedex
//
//  Created by Chris Olson on 7/12/17.
//  Copyright © 2017 Chris Olson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Always used to instantiate the protocols
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        
        // Changes the search button to Done, which removes keyboard from screen when pressed
        searchBar.returnKeyType = UIReturnKeyType.done
        
        
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        // These call all of the functions that run our App
        parsePokemonCSV() // Loads the cells with the pokemon images and names
        initAudio() // Calls the music to play
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Shows how to play audio from an mp3
    // Prepares audio file to play.
    func initAudio() {
        // Sets the path for "music.mp3"
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            
            // This forceunwraps the variable because we know it exists
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay() // Builtin, gets the music ready to play sound
            musicPlayer.numberOfLoops = -1 // This loops the sound continuously
            musicPlayer.play() // Plays the sound
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Shows how to parse a CSV file.
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
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // These are the set functions you need when you are going to have a collection view 
    
    // This function uses our base cell and recreates it for each new cell we have in our collection view. the identifier is "pokemonCell" and the data it recreates will come from the PokeCell view file
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokeCell", for: indexPath) as? PokeCell {
            
            let poke: Pokemon!
            
            // Links to the searchbar. Determins which pokemon to display based on search results
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            } else {
                
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
                
             }
            
            return cell
            
        } else {
            
            return UICollectionViewCell()
            
        }
    }
    
    // This function executes code based on the cell we select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row] //Only filtered pokemon
            
        }else {
            
            poke = pokemon[indexPath.row] //All pokemon
        }
        
        performSegue(withIdentifier: "pokemonDetailVC", sender: poke)
            
        
        
        
    }
    
    // This function determins how many cells we want to have in our collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Links to the searchbar, returns the amount of cells that the arry filteredpokemon has instances of Pokemon
        if inSearchMode {
            return filteredPokemon.count
        }
        
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
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // This section will show you how to play audio in App
    
    // Plays the music button when the button is pressed and stops when button pressed again
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        // If the music is playing and we press it, music stops, and vise verce
        if musicPlayer.isPlaying {
            
            musicPlayer.pause()
            sender.alpha = 0.2 // When button is pressed to pause, the button becomes tramsparent
            
        } else {
            
            musicPlayer.play()
            sender.alpha = 1.0 // When button is pressed to start, the button becomes solid color
            
        }
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    // This cancels the keyboard after user hits search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Shows how to use a searchbar
    
    // This function searches the app for pokemon as a new keystroke is entered in the searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Determines wether we are using the searchbar or not
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            
            collection.reloadData() // This reloads the cells displayed based on the search results
            
            view.endEditing(true) // Makes the keyboard disapear after user is done typing
            
        } else {
            inSearchMode = true
            
            // This ensures that what goes in the searchbar is transformed into lowercase so that filtering can be consistant
            let lower = searchBar.text!.lowercased()
            
            // This says that the filteredPokemon array will be equal to the pokemon arry but will be filtered so that only pokemon with the same name as in the searchbar will appear in the filteredPokemon array.
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            
            collection.reloadData()// This reloads the cells displayed based on the search results
        }
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Shows how to prepare for a segue
    // This happens before the segue occurs and it sets up the details for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // This says, if the identifier is "pokemonDetailVC" which it is, then create a variable for detailsVC and the destinaion viewcontrol is the file PokemonDetailVC
        if segue.identifier == "pokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                // This part says, if poke is the sender, which it is, then it is of class Pokemon from the Pokemon file and we then set the pokemon which is made in the Pokemon class file, equal to poke which is the new pokemon in the new viewcontroller
                if let poke = sender as? Pokemon {
                detailsVC.pokemon = poke
                }
            }
        }
    
    }
}


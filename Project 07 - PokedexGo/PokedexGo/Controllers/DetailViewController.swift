//
//  DetailViewController.swift
//  PokedexGo
//
//  Created by pike young on 2017/8/9.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameIDLabel: UILabel!
    @IBOutlet weak var pokeInfoLabel: UILabel!
    @IBOutlet weak var pokeImageView: UIImageView!
    
    var pokemon : Pokemon! {
        didSet (newPokemon) {
            self.refreshUI()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshUI()
    }

    func refreshUI() {
        nameIDLabel?.text = pokemon.name + (pokemon.id < 10 ? " #00\(pokemon.id)" : pokemon.id < 100 ? " #0\(pokemon.id)" : " #\(pokemon.id)")
        pokeImageView?.image = LibraryAPI.sharedInstance.downloadImg(pokemon.pokeImgUrl)
        pokeInfoLabel?.text = pokemon.detailInfo
        
        self.title = pokemon.name
    }
}

extension DetailViewController: PokemonSelectionDelegate {
    func pokemonSelected(_ newPokemon: Pokemon) {
        pokemon = newPokemon
    }
}


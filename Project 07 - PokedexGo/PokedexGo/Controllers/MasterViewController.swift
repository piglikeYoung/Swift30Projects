//
//  MasterViewController.swift
//  PokedexGo
//
//  Created by pike young on 2017/8/9.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol PokemonSelectionDelegate: class {
    func pokemonSelected(_ newPokemon: Pokemon)
}

class MasterViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemons = LibraryAPI.sharedInstance.getPokenmons()
    var filteredPokemons = [Pokemon]()
    weak var delegate: PokemonSelectionDelegate?
    
    fileprivate let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        filteredPokemons = pokemons
    }

    func setupUI() {
        self.title = "精灵列表"
        
        definesPresentationContext = true
        
        searchBar
            .rx.text
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(
                onNext: { [unowned self] query in
                    if query?.characters.count == 0 {
                        self.filteredPokemons = self.pokemons
                    } else {
                        self.filteredPokemons = self.pokemons.filter{ $0.name.hasPrefix(query!) }
                    }
                    self.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = self.filteredPokemons[(indexPath as NSIndexPath).row]
        
        delegate?.pokemonSelected(pokemon)
        
        if let detailViewController = self.delegate as? DetailViewController {
            splitViewController?.showDetailViewController(detailViewController.navigationController!, sender: nil)
        }
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPokemons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Cell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MasterTableViewCell
        let pokemon = filteredPokemons[indexPath.row]
        
        cell.awakeFromNib(pokemon.id, name: pokemon.name, pokeImageUrl: pokemon.pokeImgUrl)
        
        return cell
    }
}


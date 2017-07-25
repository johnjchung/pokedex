//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by John on 7/25/17.
//  Copyright © 2017 John Chung. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PokedexViewController: UIViewController {

  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var collectionView: UICollectionView!
  var pokemonData: [PokemonModel] = []
  var filteredData: [PokemonModel] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.backgroundColor = UIColor.lightGray
    collectionView.delegate = self
    collectionView.dataSource = self
      
    self.automaticallyAdjustsScrollViewInsets = false

    self.navigationItem.title = "My Pokedex"
    
    fetchData("http://pokeapi.co/api/v1/pokedex/1/", completion: {
      self.collectionView.reloadData()
    })
    
    searchBar.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func fetchData(_ url: String, completion: @escaping () -> Void) {
    Alamofire.request(url).responseData { response in
      switch response.result {
      case .success(_):
        let responseData: JSON = JSON(data: response.data!)
        if let pokemon = responseData["pokemon"].array {
          self.pokemonData = pokemon.map({ (json: JSON) -> PokemonModel in
            PokemonModel(name: json["name"].string!, resourceURI: json["resource_uri"].string!)
          })
        }
      case .failure(let error):
        self.pokemonData = []
        self.filteredData = self.pokemonData
        print(error)
      }
      completion()
    }
  }

}

extension PokedexViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.frame.width, height: 40.0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 3.0
  }
}

extension PokedexViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokedexCell", for: indexPath) as! PokedexCollectionViewCell
        let pokemonModel = filteredData[indexPath.row]
        newCell.nameLabel.text = pokemonModel.name.capitalized
        newCell.backgroundColor = UIColor.white
        return newCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count
    }
}

extension PokedexViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController: PokemonDetailViewController = storyboard.instantiateViewController(withIdentifier: "PokemonDetail") as! PokemonDetailViewController
        detailViewController.resourceURI = filteredData[indexPath.row].resourceURI
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension PokedexViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = pokemonData.filter({ (pokemon: PokemonModel) -> Bool in
            return pokemon.name.hasPrefix(searchText.lowercased()) || searchText == ""
        })
        collectionView.reloadData()
    }
}

//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by John Chung on 1/16/17.
//  Copyright © 2017 John Chung. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class PokedexViewController: UIViewController {

  @IBOutlet var collectionView: UICollectionView!
    
  var pokemonData: [PokemonModel] = []
  
    override func viewDidLoad() {
      super.viewDidLoad()

      collectionView.backgroundColor = UIColor.lightGray
      collectionView.delegate = self
      collectionView.dataSource = self
      
      self.automaticallyAdjustsScrollViewInsets = false

      self.navigationItem.title = "My Pokedex"
        
      fetchData(url: "http://pokeapi.co/api/v1/pokedex/1/", completion: {
        self.collectionView.reloadData()
      })
    }

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    }
    
    func fetchData(url: String, completion: @escaping () -> Void) {
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(_):
                do { let responseData: JSON = try JSON(data: response.data!)
                    if let pokemon = responseData["pokemon"].array {
                        self.pokemonData = pokemon.map({(json: JSON) -> PokemonModel in
                            PokemonModel(name: json["name"].stringValue, resourceURI: json["resource_uri"].stringValue)
                        })
                    }
                }
                catch let error {
                    print("error occured \(error)")
                }
            case .failure(let error):
                self.pokemonData = []
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
        let pokemonModel = pokemonData[indexPath.row]
        newCell.nameLabel.text = pokemonModel.name.capitalized
        newCell.backgroundColor = UIColor.white
        return newCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonData.count
    }
}

extension PokedexViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailController: PokemonDetailViewController = storyboard.instantiateViewController(withIdentifier: "PokemonDetail") as! PokemonDetailViewController
        detailController.resourceURI = pokemonData[indexPath.row].resourceURI
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}

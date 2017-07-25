//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by John on 7/25/17.
//  Copyright © 2017 John Chung. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PokemonDetailViewController: UIViewController {

  @IBOutlet var image: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var attackLabel: UILabel!
  @IBOutlet var defenseLabel: UILabel!
  @IBOutlet var movesList: UICollectionView!
  
  var resourceURI: String!
  var moves: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    movesList.delegate = self
    movesList.dataSource = self
    movesList.backgroundColor = UIColor.lightGray

    fetchPokemonData(resourceURI) { (pokemonData: JSON) -> Void in
      self.nameLabel.text = pokemonData["name"].string
      self.attackLabel.text = String(format: "Attack: %d", pokemonData["attack"].int!)
      self.defenseLabel.text = String(format: "Defense: %d", pokemonData["defense"].int!)
      let imageURL = String(format: "http://pokeapi.co/media/img/%d.png", pokemonData["pkdx_id"].int!)
      self.loadAndSetImage(imageURL)
      let movesArray: [JSON] = pokemonData["moves"].array!
      self.moves = movesArray.map({ (json: JSON) -> String in
        json["name"].string!
      })
      self.movesList.reloadData()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func fetchPokemonData(_ resourceURI: String, completion: @escaping (JSON) -> Void) {
    Alamofire.request("http://pokeapi.co/" + resourceURI).responseData { response in
      switch response.result {
      case .success(_):
        let pokemonData: JSON = JSON(data: response.data!)
        completion(pokemonData)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func loadAndSetImage(_ url: String) {
    if let pictureURL = URL(string: url) {
      if let data = try? Data(contentsOf: pictureURL) {
        image.image = UIImage(data: data)
      }
    }
  }

}

extension PokemonDetailViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.frame.width, height: 30.0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 3.0
  }
}

extension PokemonDetailViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoveCell", for: indexPath) as! MoveCollectionViewCell
    newCell.moveName.text = moves[indexPath.row]
    newCell.backgroundColor = UIColor.white
    return newCell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return moves.count
  }
}

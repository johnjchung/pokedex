//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by John Chung on 7/25/17.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchPokemonData(resourceURI: resourceURI) { (pokemonData: JSON) -> Void in
            self.nameLabel.text = pokemonData["name"].string
            self.attackLabel.text = String(format: "Attack: %d", pokemonData["attack"].intValue)
            self.defenseLabel.text = String(format: "Defense: %d", pokemonData["defense"].intValue)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchPokemonData(resourceURI: String, completion: @escaping (JSON) -> Void) {
        Alamofire.request("http://pokeapi.co/" + resourceURI).responseJSON { response in
            switch response.result {
            case .success(_):
                do { let pokemonData: JSON = try JSON(data: response.data!)
                completion(pokemonData)
                }
                catch let error {
                    print("error occured \(error)")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

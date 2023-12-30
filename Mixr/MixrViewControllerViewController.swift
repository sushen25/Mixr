//
//  ViewController.swift
//  Mixr
//
//  Created by sushen satturu on 30/12/2023.
//

import UIKit


class MixrViewController: UIViewController, CocktailApiDelegate {
    let apiInterface = CocktailAPIInterface()
    
    var ingredients: [String] = []
    
        
    @IBOutlet weak var ingredientSearch: UITextField!
    
    // MARK: UI Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        apiInterface.delegate = self
        apiInterface.getAllIngredients()
    }

    @IBAction func search(_ sender: Any) {
        if let ingredient = ingredientSearch.text {
            ingredients.append(ingredient)
            ingredientSearch.text = ""
        }
    }
    
    // MARK: API Methods
    func didReceiveIngredientData(_ ingredients: [String]) {
        print("Received Ingredient Data")
        print(ingredients)
        print(ingredients.count)
    }
    
    func didFail(with error: Error) {
        
    }
    
    
}


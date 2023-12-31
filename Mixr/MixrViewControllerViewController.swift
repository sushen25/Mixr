//
//  ViewController.swift
//  Mixr
//
//  Created by sushen satturu on 30/12/2023.
//

import UIKit


class MixrViewController: UIViewController, CocktailApiDelegate, UITableViewDataSource {
    let apiInterface = CocktailAPIInterface()
    
    @IBOutlet weak var ingredientTableView: UITableView!
    var allIngredients: [String] = []
    var displayIngredients: [String] = []
    
        
    @IBOutlet weak var ingredientSearch: UITextField!
    
    // MARK: UI Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        apiInterface.delegate = self
        apiInterface.getAllIngredients()
        
        ingredientTableView.dataSource = self
        
    }

    @IBAction func search(_ sender: Any) {
        // TODO - search for cocktails
    }
    
    @IBAction func filterIngredients(_ sender: UITextField) {
        guard var searchText = sender.text else {
            return print("No text")
        }
        searchText = searchText.lowercased()
        
        if (searchText == "") {
            displayIngredients = allIngredients
        } else {
            displayIngredients = allIngredients.filter { (element) -> Bool in
                return element.lowercased().contains(searchText)
            }
        }
        
        ingredientTableView.reloadData()
    }
    
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        cell.textLabel?.text = displayIngredients[indexPath.row]
        return cell
    }
    
    // MARK: API Methods
    func didReceiveIngredientData(_ ingredients: [String]) {
        allIngredients = ingredients
        displayIngredients = ingredients
        DispatchQueue.main.async {
            self.ingredientTableView.reloadData()
        }
    }
    
    func didFail(with error: Error) {
        
    }
    
    
}


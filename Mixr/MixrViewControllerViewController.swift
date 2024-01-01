//
//  ViewController.swift
//  Mixr
//
//  Created by sushen satturu on 30/12/2023.
//

import UIKit


class MixrViewController: UIViewController, CocktailApiDelegate, UITableViewDataSource, UITableViewDelegate {
    let apiInterface = CocktailAPIInterface()
    
    var allIngredients: [String:Bool] = [:]
    var displayIngredients: [String:Bool] = [:]
    var possibleDrinks: [Drink]?
    
    // MARK: - UI
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var selectedIngredients: UITextView!
    
    let showDrinksSegue: String = "showDrinksSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        apiInterface.delegate = self
        apiInterface.getAllIngredients()
        
        ingredientTableView.dataSource = self
        ingredientTableView.delegate = self
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
                return element.key.lowercased().contains(searchText)
            }
        }
        
        ingredientTableView.reloadData()
    }
    
    @IBAction func searchForDrinks(_ sender: Any) {
        let selected = allIngredients.filter {$0.value == true}
        let selectedList = selected.map { $0.key }
        if (selectedList.count > 0) {
            apiInterface.getDrinks(ingredient: selectedList[0])
        }
        
    }
    
    
    func updateSelectedIngredientsText() {
        let selected = allIngredients.filter {$0.value == true}
        let selectedList = selected.map { $0.key }
        selectedIngredients.text = selectedList.joined(separator: ", ")
    }
    
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        let ingredient = Array(displayIngredients.keys)[indexPath.row]
        cell.textLabel?.text = ingredient
        cell.accessoryType = (displayIngredients[ingredient]!) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row to visually show the selection
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        let ingredient = cell?.textLabel?.text
        
        allIngredients[ingredient!] = !allIngredients[ingredient!]!
        displayIngredients[ingredient!] = !displayIngredients[ingredient!]!
        
        // Reload the selected row to update its appearance
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        updateSelectedIngredientsText()
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showDrinksSegue {
            if let showDrinksViewController = segue.destination as? ShowDrinksViewController {
                showDrinksViewController.drinks = possibleDrinks!
            }
        }
    }
    
    
    // MARK: - API Methods
    func didReceiveIngredientData(_ ingredients: [String]) {
        for ingredient in ingredients {
            allIngredients[ingredient] = false
        }
        displayIngredients = allIngredients
        
        DispatchQueue.main.async {
            self.ingredientTableView.reloadData()
        }
    }
    
    func didFail(with error: Error) {
        
    }
    
    func didReceiveDrinksData(_ drinks: [Drink]) {
        possibleDrinks = drinks
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: self.showDrinksSegue, sender: self)
        }
        
    }
    
    
}


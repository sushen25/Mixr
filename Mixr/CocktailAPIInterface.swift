//
//  CocktailAPIInterface.swift
//  Mixr
//
//  Created by sushen satturu on 30/12/2023.
//

import Foundation

protocol CocktailApiDelegate: AnyObject {
    func didReceiveIngredientData(_ ingredients: [String])
    func didReceiveDrinksData(_ drinks: [Drink])
    func didFail(with error: Error)
}

// Ingredients list API
struct Ingredients: Codable {
    var drinks: [Ingredient]
}

struct Ingredient: Codable {
    var strIngredient1: String
}

// Drinks search API
struct Drinks: Codable {
    var drinks: [Drink]
}

struct Drink: Codable {
    var strDrink: String
    var strDrinkThumb: String
    var idDrink: String
}

class CocktailAPIInterface {
    weak var delegate: CocktailApiDelegate?
    
    var apiUrl: String = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    func createRequest(url: String, params: [String:String]) -> URLRequest? {
        guard let ingredientUrl = URL(string: url) else {
            print("Invalid URL")
            return nil
        }
        
        var urlComponents = URLComponents(url: ingredientUrl, resolvingAgainstBaseURL: true)
        let queryItems = params.map { (key, value) -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        }
        urlComponents?.queryItems = queryItems
        
        return URLRequest(url: (urlComponents?.url)!)
    }
    
    func getAllIngredients() {
        let request = self.createRequest(url: apiUrl + "list.php", params: ["i": "list"])
        
        let session = URLSession.shared
        let task = session.dataTask(with: request!) { (data, response, error) in
            // Check for errors
            if let error = error {
                    print("Error: \(error)")
                    return
                }

            // Check if data was returned
            guard let data = data else {
                print("No ingredients data received!")
                return
            }
            
            // Convert data (bytes) to a JSON object and notify the delegate about the received data
            do {
                let ingredientList = try JSONDecoder().decode(Ingredients.self, from: data)
                let ingredients = ingredientList.drinks.map { (ingredient) -> String in
                    return ingredient.strIngredient1
                }
                self.delegate?.didReceiveIngredientData(ingredients)
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    func getDrinks(ingredient:String) {
        let ingredient_id = ingredient.lowercased().replacingOccurrences(of: " ", with: "_")
        let request = self.createRequest(url: apiUrl + "filter.php", params: ["i": ingredient_id])
        
        let session = URLSession.shared
        let task = session.dataTask(with: request!) { (data, response, error) in
            // Check for errors
            if let error = error {
                    print("Error: \(error)")
                    return
                }

            // Check if data was returned
            guard let data = data else {
                print("No drinks data received!")
                return
            }
            
            // Convert data (bytes) to a JSON object and notify the delegate about the received data
            do {
                let drinksList = try JSONDecoder().decode(Drinks.self, from: data)
                self.delegate?.didReceiveDrinksData(drinksList.drinks)
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    
}

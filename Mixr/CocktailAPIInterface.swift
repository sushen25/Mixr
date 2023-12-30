//
//  CocktailAPIInterface.swift
//  Mixr
//
//  Created by sushen satturu on 30/12/2023.
//

import Foundation

protocol CocktailApiDelegate: AnyObject {
    func didReceiveIngredientData(_ ingredients: [String])
    func didFail(with error: Error)
}

// Ingredients list API
struct Ingredients: Codable {
    var drinks: [Ingredient]
}

struct Ingredient: Codable {
    var strIngredient1: String
}


class CocktailAPIInterface {
    weak var delegate: CocktailApiDelegate?
    
    var apiUrl: String = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    
    func getAllIngredients() {
        guard let ingredientUrl = URL(string: apiUrl + "list.php") else {
            print("Invalid URL")
            return
        }
        
        var urlComponents = URLComponents(url: ingredientUrl, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "i", value: "list")]
        
        let request = URLRequest(url: (urlComponents?.url)!)
        
        // Create a URLSession
        let session = URLSession.shared

        // Create a data task to make the request
    
        let task = session.dataTask(with: request) { (data, response, error) in
            // Check for errors
            if let error = error {
                    print("Error: \(error)")
                    return
                }

            // Check if data was returned
            guard let data = data else {
                print("No data received!")
                return
            }
            
            // Convert data (bytes) to a JSON object and notify the delegate about the received data
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                let ingredientList = try? JSONDecoder().decode(Ingredients.self, from: data)
                let ingredients = ingredientList?.drinks.map { (ingredient) -> String in
                    return ingredient.strIngredient1
                }
                self.delegate?.didReceiveIngredientData(ingredients!)
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        
        task.resume()

                
    }
    
    
}

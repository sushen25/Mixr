//
//  ShowDrinksViewController.swift
//  Mixr
//
//  Created by sushen satturu on 1/1/2024.
//

import UIKit

class ShowDrinksViewController: UIViewController, UITableViewDataSource {
    
    
    var drinks: [Drink] = []
    
    @IBOutlet weak var drinksTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        drinksTableView.rowHeight = CGFloat(155)
        drinksTableView.dataSource = self
    }
    
    // MARK: - Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCell", for: indexPath) as! DrinkTableViewCell
        cell.drinkLabel.text = drinks[indexPath.row].strDrink
        
        if let url = URL(string: drinks[indexPath.row].strDrinkThumb) {
            cell.loadImage(from: url, for: cell.reuseIdentifier ?? "")
        }
        
        return cell
    }

}

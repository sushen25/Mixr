//
//  DrinkTableViewCell.swift
//  Mixr
//
//  Created by sushen satturu on 1/1/2024.
//

import UIKit

class DrinkTableViewCell: UITableViewCell {
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var drinkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImage(from url: URL, for cellIdentifier: String) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if self?.reuseIdentifier == cellIdentifier {
                        self?.drinkImage.image = image
                    }
                }
            }
        }.resume()
    }


}

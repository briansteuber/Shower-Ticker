//
//  ShowerTableViewCell.swift
//  Shower Ticker
//  Brian Steuber and Tyler Gonzalez
//  Final Project
//
//  Created by Tyler Gonzalez on 11/27/20.
//

import UIKit

class ShowerTableViewCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var gallonsSavedLabel: UILabel!
    @IBOutlet var showerTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with shower: Shower) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let date = shower.date {
            dateLabel.text = dateFormatter.string(from: date)
        }
        gallonsSavedLabel.text = String(format: "%.2f", shower.waterSaved)
        showerTimeLabel.text = shower.time
    }
}

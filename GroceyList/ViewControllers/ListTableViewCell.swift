//
//  ListTableViewCell.swift
//  GroceyList
//
//  Created by Ramachandra petla on 10/26/22.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var listItemName: UILabel!
    @IBOutlet weak var checkMarkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

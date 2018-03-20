//
//  CelulaTableViewCell.swift
//  Cryptos
//
//  Created by Swift on 31/01/2018.
//  Copyright © 2018 Swift. All rights reserved.
//

import UIKit

class CelulaTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var lblMoeda: UILabel!
    @IBOutlet weak var lblVariacao: UILabel!
    @IBOutlet weak var lblCotacao: UILabel!
    @IBOutlet weak var imgMoeda: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

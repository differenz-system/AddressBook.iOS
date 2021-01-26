//
//  ListCell.swift
//  AddressBook
//
//  Created by DifferenzSystem PVT. LTD. on 01/19/2021.
//  Copyright © 2021 Differenz System. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var viewHorizontal: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewHorizontal.applyGradient()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  FibonacciTableViewCell.swift
//  SHMTableView
//
//  Created by Dominik Bucher on 17/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SHMTableView

struct FibonacciCellModel
{
    let labelTitle: String
}



class FibonacciTableViewCell: UITableViewCell
{

    @IBOutlet var label: UILabel!
    
    override func awakeFromNib() 
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FibonacciTableViewCell: SHMConfigurableRow
{
    typealias T = FibonacciCellModel
    
    func configure(_ model: T)
    {
        self.selectionStyle = .gray
        self.label.text = model.labelTitle
        
    }
    
    func configureAtWillDisplay(_ model: T)
    {
        
        
    }
    
    func configureOnHide(_ model: T)
    {
        
    }
}

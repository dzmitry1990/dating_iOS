//
//  ReplyMessagesTableViewCell.swift
//  DatingApp
//
//  Created by Dzmitry Zhuk on 08/08/2019.
//  Copyright © 2019 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class ReplyMessagesTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
          // Initialization code
        mainView.layer.borderWidth = 1.0
        mainView.layer.borderColor = UIColor(red: 156/255, green: 156/255, blue: 156/255, alpha: 1.0).cgColor
      
    }


}

//
//  EmojiMessagesTableViewCell.swift
//  DatingApp
//
//  Created by AJ on 08/08/2019.
//  Copyright © 2019 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class EmojiMessagesTableViewCell: UITableViewCell {

    @IBOutlet var downBtn: UIButton!
    @IBOutlet var perfectBtn: UIButton!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var profileBtn: UIButton!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var doubleHeartBtn: UIButton!
    @IBOutlet var chatBtn: UIButton!
    @IBOutlet var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mainView.layer.borderWidth = 1.0
        mainView.layer.borderColor = UIColor(red: 156/255, green: 156/255, blue: 156/255, alpha: 1.0).cgColor
    
        
    }


}

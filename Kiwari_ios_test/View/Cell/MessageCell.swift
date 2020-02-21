//
//  MessageCell.swift
//  Kiwari_ios_test
//
//  Created by macbook on 21/02/2020.
//  Copyright © 2020 AghaShahriyarKhan. All rights reserved.
//
import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var messageBubble: UIView!


   
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height/5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

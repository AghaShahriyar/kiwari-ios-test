//
//  Message.swift
//  Kiwari_ios_test
//
//  Created by macbook on 21/02/2020.
//  Copyright © 2020 AghaShahriyarKhan. All rights reserved.
//
import UIKit
import Firebase

struct Message {
    let sender : String
    let body : String
    let sentDate : Double
    
    var isMe : Bool {
        if Auth.auth().currentUser?.displayName == self.sender {
            return true
        } else {
            return false
        }
    }
    
    var sentDateFormatted : String {
        let date = Date.init(timeIntervalSince1970: self.sentDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}

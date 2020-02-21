//
//  ChatVC.swift
//  Kiwari_ios_test
//
//  Created by macbook on 21/02/2020.
//  Copyright © 2020 AghaShahriyarKhan. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController {
    @IBOutlet weak var navigationTitle: UILabel!
    
    @IBOutlet weak var navImage: UIImageView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var participants : [Participants] = []
    var messages : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "\(MessageCell.self)", bundle: nil), forCellReuseIdentifier: "\(MessageCell.self)")
        self.getParticipants()
        self.loadMessages()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popViewController(animated: true)
        } catch let signOutError as NSError {
            self.presentAlert(signOutError.localizedDescription, K.error)
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.displayName {
            db.collection(K.FStore.messagesCollection).addDocument(data: [K.FStore.senderField:messageSender,K.FStore.bodyField:messageBody,
                                                                          K.FStore.dateField:Date().timeIntervalSince1970]) { (error) in
                                                                            sender.isUserInteractionEnabled = true
                                                                            if let e = error {
                                                                                self.presentAlert(e.localizedDescription, K.error)
                                                                            } else {
                                                                                DispatchQueue.main.async {
                                                                                    self.messageTextField.text = ""
                                                                                }
                                                                            }
            }
        }
    }
    
    func loadMessages() {
        messages = []
        db.collection(K.FStore.messagesCollection).order(by: K.FStore.dateField).addSnapshotListener { (querySnapShot, error) in
            self.messages = []
            if let e = error {
                self.presentAlert(e.localizedDescription, K.error)
            } else {
                if let snapshotDocument = querySnapShot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        let sender = (data[K.FStore.senderField] as? String) ?? ""
                        let body = (data[K.FStore.bodyField] as? String) ?? ""
                        let sentDate = (data[K.FStore.dateField] as? Double) ?? 0.00
                        let newMessage = Message.init(sender: sender, body: body, sentDate: sentDate)
                        self.messages.append(newMessage)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            let index = IndexPath.init(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: index, at: .top, animated: true)
                        }
                    }
                    
                }
            }
        }
    }
    
    func getParticipants() {
        db.collection(K.FStore.participantsCollection).getDocuments { (querySnapShot, error) in
            self.participants = []
            if let e = error {
                self.presentAlert(e.localizedDescription, K.error)
            } else {
                if let snapshotDocument = querySnapShot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let name = data[K.FStore.participantName] as? String, let photo = data[K.FStore.participantPhoto] as? String {
                            let participant = Participants.init(name: name, photo: photo)
                            self.participants.append(participant)
                            DispatchQueue.main.async {
                                self.getOpponentParticipant()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getOpponentParticipant() {
        let currentUser = Auth.auth().currentUser
        if currentUser?.displayName == participants[0].name {
            self.setupNavigationBar(participants[1])
        } else {
            self.setupNavigationBar(participants[0])
        }
    }
    
    func setupNavigationBar(_ opponent : Participants) {
        self.navigationTitle.text = opponent.name
        self.navImage.downloaded(from: URL.init(string: opponent.photo)!)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ChatVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MessageCell.self)", for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.messageBody.text = message.body
        cell.date.text = message.sentDateFormatted
        cell.name.text = message.sender
        if message.isMe {
            cell.messageBubble.backgroundColor = UIColor.init(named: K.BrandColors.yellow)
        } else {
            cell.messageBubble.backgroundColor = UIColor.init(named: K.BrandColors.lightBlue)
        }
        return cell
    }
}

extension ChatVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
}

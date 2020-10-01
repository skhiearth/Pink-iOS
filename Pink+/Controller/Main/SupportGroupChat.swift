//
//  SupportGroups.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 25/09/20.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase
import FirebaseFirestore
import JSQMessagesViewController

class SupportGroupChat: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    
    var typeOfChat = ""
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()

    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }()
    
    override func viewDidLoad() {
        senderId = UserDefaults.standard.string(forKey: "uid")!
        let nameToDisplay = "\(UserDefaults.standard.string(forKey: "name")!) | \(UserDefaults.standard.string(forKey: "type")!)"
        senderDisplayName = nameToDisplay
        super.viewDidLoad()

        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        // CHAT ROOM
        //
        var query = Constants.refs.globalChats.queryLimited(toLast: 20)
        
        if(typeOfChat == "Survivors"){
            query = Constants.refs.survivorChats.queryLimited(toLast: 20)
        } else if(typeOfChat == "Medical"){
            query = Constants.refs.medicalChat.queryLimited(toLast: 20)
        } else if(typeOfChat == "Research"){
            query = Constants.refs.researchChat.queryLimited(toLast: 20)
        } else if(typeOfChat == "Warriors"){
            query = Constants.refs.warriorChats.queryLimited(toLast: 20)
        } else if(typeOfChat == "Global"){
            query = Constants.refs.globalChats.queryLimited(toLast: 20)
        } else if(typeOfChat == "Americas"){
            query = Constants.refs.americaChats.queryLimited(toLast: 20)
        } else if(typeOfChat == "Africa"){
            query = Constants.refs.africaChats.queryLimited(toLast: 20)
        } else if(typeOfChat == "Europe"){
            query = Constants.refs.europeChats.queryLimited(toLast: 20)
        } else if(typeOfChat == "APAC"){
            query = Constants.refs.apacChats.queryLimited(toLast: 20)
        } else {
            query = Constants.refs.globalChats.queryLimited(toLast: 20)
        }
        

        _ = query.observe(.childAdded, with: { [weak self] snapshot in

            if  let data        = snapshot.value as? [String: String],
                let id          = data["sender_id"],
                let name        = data["name"],
                let text        = data["text"],
                !text.isEmpty
            {
                if let message = JSQMessage(senderId: id, displayName: name, text: text){
                    self?.messages.append(message)

                    self?.finishReceivingMessage()
                }
            }
        })
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!{
        return messages[indexPath.item]
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!{
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!{
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!{
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat{
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!){
        
        
        // CHAT ROOM
        var ref = Constants.refs.globalChats.childByAutoId()
        
        if(typeOfChat == "Survivors"){
            ref = Constants.refs.survivorChats.childByAutoId()
        } else if(typeOfChat == "Medical"){
            ref = Constants.refs.medicalChat.childByAutoId()
        } else if(typeOfChat == "Research"){
            ref = Constants.refs.researchChat.childByAutoId()
        } else if(typeOfChat == "Warriors"){
            ref = Constants.refs.warriorChats.childByAutoId()
        } else if(typeOfChat == "Global"){
            ref = Constants.refs.globalChats.childByAutoId()
        } else if(typeOfChat == "Americas"){
            ref = Constants.refs.americaChats.childByAutoId()
        } else if(typeOfChat == "Africa"){
            ref = Constants.refs.africaChats.childByAutoId()
        } else if(typeOfChat == "Europe"){
            ref = Constants.refs.europeChats.childByAutoId()
        } else if(typeOfChat == "APAC"){
            ref = Constants.refs.apacChats.childByAutoId()
        } else {
            ref = Constants.refs.globalChats.childByAutoId()
        }

        let message = ["sender_id": senderId, "name": senderDisplayName, "text": text]

        ref.setValue(message)

        finishSendingMessage()
    }

}

import Firebase

struct Constants {
    struct refs {
        static let databaseRoot = Database.database().reference()
        
        // MARK: Regional Communities
        
        static let americaChats = databaseRoot.child("chats").child("americaChats")
        static let africaChats = databaseRoot.child("chats").child("africaChats")
        static let globalChats = databaseRoot.child("chats").child("globalChats")
        static let europeChats = databaseRoot.child("chats").child("europeChats")
        static let apacChats = databaseRoot.child("chats").child("apacChats")
        
        
        // MARK: Communities
        static let survivorChats = databaseRoot.child("chats").child("survivorChats")
        static let warriorChats = databaseRoot.child("chats").child("warriorChats")
        static let medicalChat = databaseRoot.child("chats").child("medicalChat")
        static let researchChat = databaseRoot.child("chats").child("researchChat")
        static let globalChat = databaseRoot.child("chats").child("globalChats")
        
    }
}

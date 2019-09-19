//
//  DocumetsModel.swift
//  SubmitForm
//
//  Created by Roman Trekhlebov on 17/09/2019.
//  Copyright © 2019 Roman Trekhlebov. All rights reserved.
//

import Foundation
import RealmSwift

class DocumentModel: Object  {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var generatedDate = Date()
    @objc dynamic var status = ""
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var phone = ""
    @objc dynamic var email = ""
    
    
    @objc private dynamic var privateReason =  VisitReason.pickUp.rawValue
    var reason: VisitReason {
        get { return VisitReason(rawValue: privateReason)! }
        set { privateReason = newValue.rawValue }
    }
    
//    @objc dynamic var resultOptions: [String]?
    public private(set) var resultOptions = List<String>()
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["generatedDate"]
    }
}


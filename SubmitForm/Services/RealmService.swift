//
//  RealmService.swift
//  SubmitForm
//
//  Created by Roman Trekhlebov on 18/09/2019.
//  Copyright © 2019 Roman Trekhlebov. All rights reserved.
//

import Foundation


import Foundation
import RealmSwift

class RealmService {
    
    var realm: Realm {
        let config = Realm.Configuration()
        Realm.Configuration.defaultConfiguration = config
        do {
            let realm = try Realm()
            return realm
        } catch let error as NSError {
            fatalError("Error using realm: \(error)")
        }
        
        
    }
    
    func addDocument(fName: String, lName: String, phone: String, email: String, reason: VisitReason, options: [String]?) {
        
        let document = DocumentModel()
        document.firstName = fName
        document.lastName = lName
        document.phone = phone
        document.email = email
        document.reason = reason
        if let options = options {
            options.forEach { (item) in
                document.resultOptions.append(item)
            }
            
        }
        
        
        
        do {
            try realm.write {
                realm.add(document)
            }
            
        }catch let error as NSError {
            fatalError("Error on adding Person to realm \(error)")
        }
        
        
        
    }
//    func removePerson(index: Int) {
//        let persons = RealmService().getAllPersons()
//        let person = persons[index]
//        do {
//            try realm.write {
//                realm.delete(person)
//            }
//        }catch let error as NSError {
//            fatalError("Error on deleting Person from realm \(error)")
//        }
//
//    }
    
//    func getPerson(index: Int) -> PersonViewModel{
//        let name = RealmService().getAllPersons()[index].name
//
//        let personVM = PersonViewModel(name)
//        return personVM
//
//
//    }
//
    func getAllDocuments() -> Results<DocumentModel> {
        let result = realm.objects(DocumentModel.self)
        return result
    }
    
}

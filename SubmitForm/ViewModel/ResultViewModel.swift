//
//  ResultViewModel.swift
//  SubmitForm
//
//  Created by Roman Trekhlebov on 18/09/2019.
//  Copyright © 2019 Roman Trekhlebov. All rights reserved.
//

import Foundation

struct ResultViewModel {
    let firstName: String?
    let lastName: String?
    let phone: String?
    let email: String?
    let reason: VisitReason?
    var resultOptions: [String]?
    
    func getDocumentsCount() -> Int {
        return RealmService().getAllDocuments().count
    }
    
    func addToRealm() {
        RealmService().addDocument(fName: self.firstName!, lName: self.lastName!, phone: self.phone!, email: self.email!, reason: self.reason!, options: self.resultOptions ?? nil)
    }
}


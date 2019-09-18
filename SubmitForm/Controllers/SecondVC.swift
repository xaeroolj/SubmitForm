//
//  SecondVC.swift
//  SubmitForm
//
//  Created by Roman Trekhlebov on 17/09/2019.
//  Copyright © 2019 Roman Trekhlebov. All rights reserved.
//

import UIKit

class SecondVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var reason: VisitReason?
    var sourceStrings: [String]!
    var othereReason: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        initViewUI()

        // Do any additional setup after loading the view.
        
    }
    func setupView(reason: VisitReason){
        self.reason = reason
        print(reason)
        
    }
    fileprivate func initViewUI() {
    
        guard let reason = self.reason else {return}
        self.titleLabel.text = reason.rawValue
        
        switch reason {
        case .dropOff:
            self.sourceStrings = DropOffOptions.allCases.map { $0.rawValue }
            break
        case .pickUp:
            self.sourceStrings = PickUpOptions.allCases.map { $0.rawValue}
            break
        case .specialistApointment:
            
            self.sourceStrings = SpecialistApointmentOptions.allCases.map {$0.rawValue}
            self.tableView.allowsMultipleSelection = false
            break
        case .reaserchApointment:
            
            self.sourceStrings = ReaserchApointmentOptions.allCases.map {$0.rawValue}
            self.tableView.allowsMultipleSelection = false
            break
        case .referalService:
            self.sourceStrings = ReferalServiceHelpOptions.allCases.map {$0.rawValue}
            self.tableView.allowsMultipleSelection = false
            break
        default:
            break
        }
    }
    
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBtnWasPressed(_ sender: Any) {
        guard let indexArray = tableView.indexPathsForSelectedRows else {return}
//        indexArray.sorted(by: <)
        let resultArray = indexArray.sorted(by: <).map {sourceStrings[$0.row]}
        if let otherReason = self.othereReason {
            var array = resultArray
            array.removeLast()
            array.append("other: \(otherReason)")
            print(array.joined(separator: ", "))
        }else {
            print(resultArray.joined(separator: ", "))

        }
        
        
    }
    

}
extension SecondVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sourceStrings[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == sourceStrings!.count - 1 && self.reason! == .pickUp {
            requestComment()
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    fileprivate func requestComment() {
        let alert = UIAlertController(title: "Other reason", message: "Other (Please type in the box below) / Otro (porfavor especifique en la caja de abajo)", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Other reason"
        }
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.changeOtherCell(reason: alert.textFields?.last?.text)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    fileprivate func changeOtherCell(reason: String?) {
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: sourceStrings!.count - 1, section: 0)),
        let reason = reason, reason.count > 0 else {return}
        
        cell.textLabel?.text = "Other (\(reason))"
        self.othereReason = reason
        
    }
    
}



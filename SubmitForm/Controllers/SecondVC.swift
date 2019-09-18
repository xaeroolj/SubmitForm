//
//  SecondVC.swift
//  SubmitForm
//
//  Created by Roman Trekhlebov on 17/09/2019.
//  Copyright © 2019 Roman Trekhlebov. All rights reserved.
//

import UIKit

class SecondVC: UIViewController {

    @IBOutlet weak var apointmentLableStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var downConstraint: NSLayoutConstraint! // 115
    var reason: VisitReason?
    var sourceStrings: [String]!
    var othereReason: String?
    var resultVM: ResultViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyboardClosetap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        keyboardClosetap.cancelsTouchesInView = false
        view.addGestureRecognizer(keyboardClosetap)
        
        tableView.delegate = self
        tableView.dataSource = self
        initViewUI()

        // Do any additional setup after loading the view.
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kayboardWillHide(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    @objc func kayboardWillHide(notification: Notification) {
        downConstraint.constant = 115
        //        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        
        //        view.frame.origin.y = -keyboardRect.height
        downConstraint.constant = keyboardRect.height + 20
        
    }
    
    @objc func dismissKeyboard() {
        
        self.view.endEditing(true)
    }
    
    @IBAction func onEditDob(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        timeTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func setupView(vm: ResultViewModel){
        self.reason = vm.reason!
        self.resultVM = vm
//        self.reason = reason
//        print(reason)
        
    }
    fileprivate func initViewUI() {
        timeTextField.isHidden = true
        apointmentLableStackView.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        timeTextField.text = dateFormatter.string(from: Date())
    
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
            timeTextField.isHidden = false
            apointmentLableStackView.isHidden = false
            break
        case .reaserchApointment:
            
            self.sourceStrings = ReaserchApointmentOptions.allCases.map {$0.rawValue}
            self.tableView.allowsMultipleSelection = false
            timeTextField.isHidden = false
            apointmentLableStackView.isHidden = false
            
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
        let resultArray = indexArray.sorted(by: <).map {sourceStrings[$0.row]}
        if let otherReason = self.othereReason {
            var array = resultArray
            array.removeLast()
            array.append("other: \(otherReason)")
            self.resultVM!.resultOptions = array
//            print(self.resultVM)
            self.resultVM!.addToRealm()
            print("vms Count = \(self.resultVM!.getDocumentsCount())")
            
        }else if reason! == .specialistApointment || reason! == .reaserchApointment  {
            self.resultVM!.resultOptions = resultArray
            self.resultVM!.resultOptions?.append("apoimentTime: \(self.timeTextField.text!)")
//            print(self.resultVM)
            self.resultVM!.addToRealm()
            print("vms Count = \(self.resultVM!.getDocumentsCount())")
        } else {
            self.resultVM!.resultOptions = resultArray
//            print(self.resultVM)
            self.resultVM!.addToRealm()
            print("vms Count = \(self.resultVM!.getDocumentsCount())")

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



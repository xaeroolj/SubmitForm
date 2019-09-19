//
//  MainVC.swift
//  SubmitForm
//
//  Created by Roman Trekhlebov on 17/09/2019.
//  Copyright © 2019 Roman Trekhlebov. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var visitorSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var reasonPicker: UIPickerView!
    
    var reasonPickerValues: [String] = VisitReason.allCases.map {$0.rawValue}
    var resultVM: ResultViewModel?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let keyboardClosetap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(keyboardClosetap)

        reasonPicker = UIPickerView()
        
        reasonPicker.dataSource = self
        reasonPicker.delegate = self
        
        reasonTextField.inputView = reasonPicker
        reasonTextField.text = reasonPickerValues[0]
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
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
    
    
    
    @IBAction func nextBtnWasPressed(_ sender: Any) {
        if validateName(firstNameTextField.text) &&
            validateName(lastNameTextField.text) &&
            validatePhone(phoneTextField.text) &&
            validateMail(emailTextField.text) {
            goTonextScreen()
        } else {
            showAlert(title: "Check fields", message: "check all field for correct data.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dropView" {
            let vc = segue.destination as? SecondVC
            let reason = VisitReason(rawValue: reasonTextField.text!)!
            vc?.setupView(vm: resultVM!)
        }
    }
    
    @objc func kayboardWillHide(notification: Notification) {
        bottomConstraint.constant = 115
        //        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        
        //        view.frame.origin.y = -keyboardRect.height
        bottomConstraint.constant = keyboardRect.height + 20
        
    }
    
    @objc func dismissKeyboard() {
        
        self.view.endEditing(true)
    }
    

    fileprivate func goTonextScreen() {
        guard let reason = VisitReason(rawValue: reasonTextField.text!) else {return}
        switch reason {
        case .dropOff:
            self.createRecord()
            performSegue(withIdentifier: "dropView", sender: nil)
            break
        case .pickUp:
            self.createRecord()
            performSegue(withIdentifier: "dropView", sender: nil)
            break
        case .specialistApointment:
            self.createRecord()
            performSegue(withIdentifier: "dropView", sender: nil)
            break
        case .reaserchApointment:
            self.createRecord()
            performSegue(withIdentifier: "dropView", sender: nil)
            break
        case .referalService:
            self.createRecord()
            performSegue(withIdentifier: "dropView", sender: nil)
            break
        case .diaperBox:
            //need to go to finish
            self.createRecord()
            self.resultVM!.addToRealm()
            print("vms Count = \(self.resultVM!.getDocumentsCount())")
            self.clearForm()
            break
        case .noReason:
            //will show dialog box for input reason
            self.showDialogBox()
            
            break
        }
        
    }
    
    fileprivate func showDialogBox() {
        let alert = UIAlertController(title: "Reason", message: "If you don't have any appointment, please share the reason for your visit", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "reason"
        }
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.createRecord(reason: alert.textFields?.last?.text)
            self.resultVM!.addToRealm()
            print("vms Count = \(self.resultVM!.getDocumentsCount())")
            self.clearForm()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }

    fileprivate func createRecord(reason: String?) {
        guard let reason = reason, reason.count > 0 else {return}
        var visitorStatusString = ""
        switch visitorSegmentedControl.selectedSegmentIndex {
        case 0:
            visitorStatusString = "Parent / PADRE"
        default:
            visitorStatusString = "Provider / PROVEEDOR"
        }
        let vm = ResultViewModel(status: visitorStatusString , firstName: firstNameTextField.text, lastName: lastNameTextField.text, phone: phoneTextField.text, email: emailTextField.text, reason: VisitReason(rawValue: reasonTextField.text!), resultOptions: [reason])
        self.resultVM = vm

    }
    fileprivate func createRecord() {
        var visitorStatusString = ""
        switch visitorSegmentedControl.selectedSegmentIndex {
        case 0:
            visitorStatusString = "Parent / PADRE"
        default:
            visitorStatusString = "Provider / PROVEEDOR"
        }
        let vm = ResultViewModel(status: visitorStatusString, firstName: firstNameTextField.text, lastName: lastNameTextField.text, phone: phoneTextField.text, email: emailTextField.text, reason: VisitReason(rawValue: reasonTextField.text!), resultOptions:nil)
        self.resultVM = vm

    }
    
    
}
extension MainVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reasonPickerValues.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reasonPickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        reasonTextField.text = reasonPickerValues[row]
        self.view.endEditing(true)
    }
    
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {
        self.clearForm()
        //will clear
    }
    
    fileprivate func clearForm() {
        self.visitorSegmentedControl.selectedSegmentIndex = 0
        self.firstNameTextField.text = ""
        self.lastNameTextField.text = ""
        self.phoneTextField.text = ""
        self.emailTextField.text = ""
        reasonTextField.text = reasonPickerValues[0]
        
    }
}

extension MainVC: UITextFieldDelegate{
    fileprivate func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    fileprivate func validateName(_ string: String?) -> Bool {
        guard let string = string else {return false}
        if string.count > 0 {
            return true
        }else {
            return false
        }
    }
    
    fileprivate func validatePhone(_ string: String?) -> Bool {
        guard let string = string else {return false}
        if string.count == 10 {
            return true
        }else {
            return false
        }
    }
    fileprivate func validateMail(_ string: String?) -> Bool {
        guard let string = string else {return false}
        if string.count > 0 && string.contains("@") {
            return true
        }else {
            return false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 0: //First Name
            let item = textField
            if validateName(item.text) {
                view.viewWithTag(1)?.becomeFirstResponder()
            } else {
                self.showAlert(title: "Field Not Validated", message: "First Name not valid")
            }
        case 1: //Last Name
            let item = textField
            if validateName(item.text) {
                view.viewWithTag(2)?.becomeFirstResponder()
            } else {
                self.showAlert(title: "Field Not Validated", message: "Last Name not valid")
            }
        case 2: //Mobile Number
            let item = textField
            if validatePhone(item.text) {
                view.viewWithTag(3)?.becomeFirstResponder()
            } else {
                self.showAlert(title: "Field Not Validated", message: "Mobile number not valid")
            }
        case 3: //Email
            let item = textField
            if validateMail(item.text) {
                goTonextScreen()
                
            } else {
                self.showAlert(title: "Field Not Validated", message: "Email not valid")
            }
            
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}

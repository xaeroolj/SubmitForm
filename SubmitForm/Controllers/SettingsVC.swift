//
//  SettingsVC.swift
//  SubmitForm
//
//  Created by Roman Trekhlebov on 18/09/2019.
//  Copyright © 2019 Roman Trekhlebov. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsVC: UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var exportBtn: UIButton!
    
    var notificationToken: NotificationToken? = nil
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Observe Results Notifications
        notificationToken = RealmService().getAllDocuments().observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                // Always apply updates in the following order: deletions, insertions, then modifications.
                // Handling insertions before deletions may result in unexpected behavior.
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
        
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    
    @IBAction func exportBtnWasPressed(_ sender: Any) {
        self.prepareCSV()
    }
    
    @IBAction func clearBtnWasPressed(_ sender: Any) {
        RealmService().clearAllData()
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func prepareCSV() {
        let list = RealmService().getAllDocuments()
        if list.count == 0 {return}
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let datString = formatter.string(from: Date())
        let fileName = "Export \(datString).csv"
//        print(fileName)
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        var csvText = "DateTIME,VisitorStatus,FirstName,lastName,phone,email,reason,reasonOptions\n"
        if list.count > 0 {
            
            for record in list {
//                let formatter = DateFormatter()
                // initially set the format based on your datepicker date / server String
//                formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
                //        07/16/20 02:07 AM
                let dateString = formatter.string(from: record.generatedDate)
                
                
                
                var newLine = "\(dateString),\(record.status),\(record.firstName),\(record.lastName),\(record.phone),\(record.email),\(record.reason.rawValue)"
                
                if record.resultOptions.count > 0 {
                    newLine += ","
                    for item in record.resultOptions {
                        newLine += "\(item); "
                    }
                    newLine.removeLast(2)
                    newLine += "\n"
                }else {
                    newLine += "\n"
                }
                csvText.append(contentsOf: newLine)
            }
            do {
                try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                
                let activityViewController = UIActivityViewController(activityItems: [path!], applicationActivities: nil)
//                activityViewController.excludedActivityTypes = [
//                    .assignToContact,
//                    .print,
//                    .mail,
//                    .markupAsPDF,
//                    .airDrop
//                ]
                
                if let popoverController = activityViewController.popoverPresentationController {
                    popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                    popoverController.sourceView = self.view
                    popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                }
                
                self.present(activityViewController, animated: true, completion: nil)
                
            } catch {
                
                print("Failed to create file")
                print("\(error)")
            }
        }
        
    }
    
}

extension SettingsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RealmService().getAllDocuments().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let model = RealmService().getDocument(index: indexPath.row)
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss "
        //        07/16/20 02:07 AM
        let dateString = formatter.string(from: model.generatedDate)
        cell.textLabel?.text = dateString
        
        var resultString = "visitorStatus: \(model.status), FirstName: \(model.firstName), lastName: \(model.lastName)"
        resultString += "phone: \(model.phone), email: \(model.email), "
        resultString += "reason: \(model.reason.rawValue)" //", reasonOptions: \(model.resultOptions)"
        if model.resultOptions.count > 0 {
            resultString += ", "
            for item in model.resultOptions {
                resultString += "\(item); "
            }
            resultString.removeLast(2)
        }
        
        
        cell.detailTextLabel?.text = resultString
        return cell
    }
    
    
    
}

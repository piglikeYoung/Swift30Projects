//
//  AddContactViewController.swift
//  Birthdays
//
//  Created by pike young on 2017/9/14.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

protocol AddContactViewControllerDelegate {
    func didFetchContacts(_ contacts: [CNContact])
}

class AddContactViewController: UIViewController {

    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var pickerMonth: UIPickerView!
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var currentlySelectedMonthIndex = 1
    var delegate: AddContactViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerMonth.delegate = self
        pickerMonth.dataSource = self
        txtLastName.delegate = self
        
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddContactViewController.performDoneItemTap))
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
    @IBAction func showContacts(_ sender: Any) {
        let contactPickerViewController = CNContactPickerViewController()
        // 生日不为空的联系人
        contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "birthday != nil")
        
        contactPickerViewController.delegate = self
        
        contactPickerViewController.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey]
        
        present(contactPickerViewController, animated: true, completion: nil)
    }

}

// MARK: - CNContactPickerDelegate

extension AddContactViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        delegate.didFetchContacts([contact])
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UIPickerView Delegate and Datasource functions

extension AddContactViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return months.count
    }
}

extension AddContactViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return months[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentlySelectedMonthIndex = row + 1
    }
}

// MARK: UITextFieldDelegate functions

extension AddContactViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 判断权限
        AppDelegate.appDelegate.requestForAccess { (accessGranted) in
            if accessGranted {
                // 根据输入的姓名筛选
                let predicate = CNContact.predicateForContacts(matchingName: self.txtLastName.text!)
                // 指定你想获取的联系人的部分信息
                let keys = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactEmailAddressesKey, CNContactBirthdayKey] as [Any]
                var contacts = [CNContact]()
                var warningMessage: String!
                
                let contactsStore = AppDelegate.appDelegate.contactStore
                do {
                    contacts = try contactsStore.unifiedContacts(matching: predicate, keysToFetch: keys as! [CNKeyDescriptor])
                    
                    if contacts.count == 0 {
                        warningMessage = "No contacts were found matching the given name."
                    }
                } catch {
                    warningMessage = "Unable to fetch contacts."
                }
                
                if let warningMessage = warningMessage {
                    DispatchQueue.main.async {
                        Helper.show(message: warningMessage)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.delegate.didFetchContacts(contacts)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        
        return true
    }
    
    // MARK: Custom functions
    
    func performDoneItemTap() {
        AppDelegate.appDelegate.requestForAccess { (accessGranted) in
            if accessGranted {
                var contacts = [CNContact]()
                // 指定你想获取的联系人的部分信息
                let keys = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey] as [Any]
                
                do {
                    let contactStore = AppDelegate.appDelegate.contactStore
                    // 遍历所有的联系人
                    try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor]), usingBlock: { [weak self] (contact, pointer) in
                        // 生日不为空，并且等于所选月份
                        if contact.birthday != nil && contact.birthday?.month == self?.currentlySelectedMonthIndex {
                            contacts.append(contact)
                        }
                    })
                    
                    DispatchQueue.main.async {
                        self.delegate.didFetchContacts(contacts)
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                } catch let error as NSError {
                    print(error.description, separator: "", terminator: "\n")
                }
            }
        }
    }
    
}

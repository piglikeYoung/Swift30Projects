//
//  ViewController.swift
//  Birthdays
//
//  Created by pike young on 2017/9/13.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController {

    @IBOutlet weak var tblContacts: UITableView!
    
    var contacts = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor(red: 241.0/255.0, green: 107.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        
        configureTableView()
    }
    
    func configureTableView() {
        tblContacts.delegate = self
        tblContacts.dataSource = self
        tblContacts.register(UINib(nibName: "ContactBirthdayCell", bundle: nil), forCellReuseIdentifier: "idCellContactBirthday")
    }

    // MARK: IBAction functions
    @IBAction func addContact(_ sender: Any) {
        performSegue(withIdentifier: "idSegueAddContact", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "idSegueAddContact" {
                let addContactViewController = segue.destination as! AddContactViewController
                addContactViewController.delegate = self
            }
        }
    }
}

// MARK: UITableView Delegate and Datasource functions

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellContactBirthday") as! ContactBirthdayCell
        
        let currentContact = contacts[indexPath.row]
        
        // 取出全名
        cell.lblFullname.text = CNContactFormatter.string(from: currentContact, style: .fullName)
        
        // 检查需要的信息是否存在，否则直接取出会崩溃
        if !currentContact.isKeyAvailable(CNContactBirthdayKey) || !currentContact.isKeyAvailable(CNContactImageDataKey) ||  !currentContact.isKeyAvailable(CNContactEmailAddressesKey) {
            // 没有联系人信息，根据 contact.identifier 去查询，再更新数据源
            refetch(contact: currentContact, atIndexPath: indexPath)
        } else {
            // Set the birthday info.
            if let birthday = currentContact.birthday {
                cell.lblBirthday.text = birthday.asString
            } else {
                cell.lblBirthday.text = "Not available birthday data"
            }
            
            // Set the contact image.
            if let imageData = currentContact.imageData {
                cell.imgContactImage.image = UIImage(data: imageData)
            }
            
            // Set the contact's home email address.
            var homeEmailAddress: String!
            // 遍历邮箱数组，找出家庭邮箱
            for emailAddress in currentContact.emailAddresses {
                if emailAddress.label == CNLabelHome {
                    homeEmailAddress = emailAddress.value as String
                    break
                }
            }
            
            if let homeEmailAddress = homeEmailAddress {
                cell.lblEmail.text = homeEmailAddress
            } else {
                cell.lblEmail.text = "Not available home email"
            }
        }
        
        return cell
    }
    
    /// 获取某个联系人的信息，用于替换数据源中的联系人
    ///
    /// - Parameters:
    ///   - contact: 联系人
    ///   - indexPath: 数据源IndexPath
    fileprivate func refetch(contact: CNContact, atIndexPath indexPath: IndexPath) {
        AppDelegate.appDelegate.requestForAccess { (accessGranted) in
            if accessGranted {
                // 查询联系人的内容
                let keys = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey] as [Any]
                
                do {
                    let contactRefetched = try AppDelegate.appDelegate.contactStore.unifiedContact(withIdentifier: contact.identifier, keysToFetch: keys as! [CNKeyDescriptor])
                    // 替换数据源数据
                    self.contacts[indexPath.row] = contactRefetched
                    
                    DispatchQueue.main.async {
                        self.tblContacts.reloadRows(at: [indexPath], with: .automatic)
                    }
                } catch {
                    print("Unable to refetch the contact: \(contact)", separator: "", terminator: "\n")
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contacts.remove(at: indexPath.row)
            tblContacts.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contacts[indexPath.row]
        
        let keys = [CNContactBirthdayKey] as [Any]
        
        // areKeysAvailable 同时检查多个keys，isKeyAvailable 是检查单个
        if selectedContact.areKeysAvailable([CNContactViewController.descriptorForRequiredKeys()]) {
            let contactViewController = CNContactViewController(for: selectedContact)
            contactViewController.contactStore = AppDelegate.appDelegate.contactStore
            contactViewController.displayedPropertyKeys = keys
            navigationController?.pushViewController(contactViewController, animated: true)
        } else {
            AppDelegate.appDelegate.requestForAccess(completionHandler: { (accessGranted) in
                if accessGranted {
                    do {
                        let contactRefetched = try AppDelegate.appDelegate.contactStore.unifiedContact(withIdentifier: selectedContact.identifier, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
                        
                        DispatchQueue.main.async {
                            let contactViewController = CNContactViewController(for: contactRefetched)
                            contactViewController.contactStore = AppDelegate.appDelegate.contactStore
                            contactViewController.displayedPropertyKeys = keys
                            self.navigationController?.pushViewController(contactViewController, animated: true)
                        }
                    } catch {
                        print("Unable to refetch the selected contact.", separator: "", terminator: "\n")
                    }
                }
            })
        }
    }
}

extension ViewController: AddContactViewControllerDelegate {
    
    /// 代理回调，设置筛选的联系人
    ///
    /// - Parameter contacts: 联系人
    func didFetchContacts(_ contacts: [CNContact]) {
        for contact in contacts {
            self.contacts.append(contact)
        }
        
        tblContacts.reloadData()
    }
}

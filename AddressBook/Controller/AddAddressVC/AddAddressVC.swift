//
//  AddAddress.swift
//  AddressBook
//
//  Created by MohiniPatel on 9/20/17.
//  Copyright © 2017 Differenz System. All rights reserved.
//

import UIKit
import CoreData

protocol AddressDelegate {
    
    /**
     This method is used to send information about newly added User.
        - Parameter user: Newly created User object
     */
    func add(user: User)
    
    /**
     This method is used to send information about updated User.
     - Parameters:
        - index: Array index of user object that is updated
        - user: Updated User object
     */
    func replaceObject(at index: Int, with user: User)
    
    /**
     This method is used to send information about deleted User.
        - Parameter index: Array index of deleted User object
     */
    func deleteUser(at index: Int)
}

class AddAddressVC: BaseView, UITextFieldDelegate {
    
    //MARK: - IBoutlet
    @IBOutlet weak var containerViewTopOutlet: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTopOutlet: NSLayoutConstraint!
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    //MARK: - variables
    
    var delegate: AddressDelegate?
    var editUser: User?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var users = [User]()
    var editUserIndex = 0
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Instance methods
    
    
    /**
     This method is used for initial configuration of Controller.
     */
    func initialConfig() {
        self.setUpNavigationBar()
        self.txtName.setAttributedPlaceHolder(with: .gray)
        self.txtEmail.setAttributedPlaceHolder(with: .gray)
        self.txtPhoneNo.setAttributedPlaceHolder(with: .gray)
        
        //Setup data if it is update user 
        if let user = editUser {
            self.txtName.text = user.name
            self.txtEmail.text = user.email
            self.txtPhoneNo.text = user.contactno
            activeSwitch.isOn = user.isactive
            self.btnSave.setTitle("Update", for: .normal)
            self.btnDelete.setTitle("Delete", for: .normal)
        }

        //Gesture to dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }    
    
    /**
     This method is used to setup navigation bar.
     */
    func setUpNavigationBar() {
        self.title = "Detail"
        self.setLeftNavigationItem(with: "Address Book", action: #selector(backClick(_:)))
        self.setRightNavigationItem(with: "Logout", action: #selector(logoutClick(_:)))
    }
    
    /**
     This method is used to validate user input.
        - Returns: Return boolean value to indicate input data is valid or not.
     */
    func isValidUserInput() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{1,}(\\.[A-Za-z]{1,}){0,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self.txtEmail.text)
        if self.txtName.isEmpty {
            Utilities.showAlert(msg: Constant.ValidationMessage.kEmptyName, vc: self)
            return false
        }
        else if self.txtEmail.isEmpty {
            Utilities.showAlert(msg: Constant.ValidationMessage.kEmptyEmail, vc: self)
            return false
        }
        else if (!result) {
            Utilities.showAlert(msg: Constant.ValidationMessage.kInvalidEmail, vc: self)
            return false
        }
        else if self.txtPhoneNo.isEmpty {
            Utilities.showAlert(msg: Constant.ValidationMessage.kEmptyContactNo, vc: self)
            return false
        }
        else if self.txtPhoneNo.text?.count != 10 {
            Utilities.showAlert(msg: Constant.ValidationMessage.kInvalidContactNo, vc: self)
            return false
        }
        return true
    }
    
    /**
     This method is used to set data in User object.
        - Parameter user: Object of User class.
     */
    func setUserData(user: User) {
        user.name = self.txtName.text
        user.email = self.txtEmail.text
        user.contactno = self.txtPhoneNo.text
        user.isactive = activeSwitch.isOn
    }
    
    //MARK: - Tap gesture method
    
    /**
     This method is used to handle the action for UITapGestureRecognizer.
        - Parameter sender: Object of UITapGestureRecognizer.
     */
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Prevent user to input more than 10 digit in contact number field
        if textField == txtPhoneNo, let text = textField.text {
            return text.replacingCharacters(in: range, with: string).count <= 10
        }
        return true
    }
    
    //MARK: - Action methods
    
    /**
     This method is used to handle back button click.
        - Parameter sender: action button
     */
    @objc func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     This method is used to handle logout button click.
     - Parameter sender: action button
     */
    @objc func logoutClick(_ sender: Any) {
        //Set Userdefaults IsLogin key to false
        UserDefaults.standard.set(false, forKey: Constant.UserDefaultsKey.IsLogin)
        
        //Set the root view controller with login screen.
        self.appDelegate.setupRootView()
    }
    
    /**
     This method is used to handle delete button click.
        - Parameter sender: action button
     */
    @IBAction func deleteClick(_ sender: Any) {
        if let user = editUser {
            let alertController = UIAlertController(title: "", message: "Are you sure you want to delete?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                let context: NSManagedObjectContext
                if #available(iOS 10.0, *) {
                    context = self.appDelegate.persistentContainer.viewContext
                    
                } else {
                    // Fallback on earlier versions
                    context = self.appDelegate.managedObjectContext
                }
                //Delete the object and save the context
                context.delete(user)
                try? context.save()
                
                //Call the delegate method to remove user object from list
                self.delegate?.deleteUser(at: self.editUserIndex)
                self.navigationController?.popViewController(animated: true)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /**
     This method is used to handle save/update button click.
        - Parameter sender: action button
     */
    @IBAction func saveClick(_ sender: Any) {
        self.view.endEditing(true)
        if !isValidUserInput() {
            return
        }
        let context: NSManagedObjectContext
        if #available(iOS 10.0, *) {
            context = appDelegate.persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            context = appDelegate.managedObjectContext
        }
        if let user = editUser {
            self.setUserData(user: user)
            
            //Call the delegate method to update user object in list
            self.delegate?.replaceObject(at: editUserIndex, with: user)
        }
        else {
            //Create new User object
            let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
            self.setUserData(user: user)
            
            //Call the delegate method to add new user object in list
            self.delegate?.add(user: user)
        }
        //Save the context after adding/updating User object.
        try? context.save()
        self.navigationController?.popViewController(animated: true)
    }
}

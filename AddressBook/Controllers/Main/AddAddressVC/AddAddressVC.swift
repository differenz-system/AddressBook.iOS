//
//  AddAddress.swift
//  AddressBook
//
//  Created by DifferenzSystem PVT. LTD. on 01/19/2021.
//  Copyright © 2021 Differenz System. All rights reserved.
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
    func replaceObject(at index: Int,with user: User)
    
    /**
     This method is used to send information about deleted User.
        - Parameter index: Array index of deleted User object
     */
    func deleteUser(at index: Int , at sectionIndex: Int)
}

class AddAddressVC: BaseView, UITextFieldDelegate {
    
    //MARK: - IBoutlet
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var imgBg: UIImageView!
    
    //MARK: - variables
    
    var delegate: AddressDelegate?
    var editUser: User?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var users = [User]()
    var editUserIndex = 0
    var editUserSection = 0
    
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
       
        initialConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.btnSave.applyGradient()
        self.btnDelete.applyGradient()
    }
    //MARK: - Instance methods
    
    
    /**
     This method is used for initial configuration of Controller.
     */
    func initialConfig() {
        imgBg.roundBottomCorners(radius: 30)

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
     This method is used to validate user input.
        - Returns: Return boolean value to indicate input data is valid or not.
     */
    func isValidUserInput() -> Bool {
        
        if self.txtName.isEmpty {
            Utilities.showAlert(msg: Constant.ValidationMessage.kEmptyName, vc: self)
            return false
        }
        else if self.txtEmail.isEmpty {
            Utilities.showAlert(msg: Constant.ValidationMessage.kEmptyEmail, vc: self)
            return false
        }
        else if (!self.txtEmail.isValidEmailField()) {
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
    
    @IBAction func btnBackTouchUpInsite(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     This method is used to handle logout button click.
     - Parameter sender: action button
     */
    @IBAction func btnLogoutTouchUpInsite(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: Constant.UserDefaultsKey.IsLogin)
        
        //Set the root view controller with login screen.
        self.appDelegate.setupRootView()
    }
    /**
     This method is used to handle delete button click.
        - Parameter sender: action button
     */
    @IBAction func btnDeleteTouchUpInsite(_ sender: Any) {
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
                self.delegate?.deleteUser(at: self.editUserIndex, at: self.editUserSection)
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
    @IBAction func btnSaveTouchUpInsite(_ sender: Any) {
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
            self.delegate?.replaceObject(at:editUserIndex,with: user)
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

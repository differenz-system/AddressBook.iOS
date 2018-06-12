//
//  LoginVC.swift
//  AddressBook
//
//  Created by MohiniPatel on 9/20/17.
//  Copyright © 2017 Differenz System. All rights reserved.
//

import UIKit
import SVProgressHUD
import FBSDKLoginKit

class LoginVC: BaseView {
    
    //MARK: - IBoutlet
    @IBOutlet weak var txtUname: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnFb: UIButton!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialConfig()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : - Instance methods
    
    /**
     This method is used for initial configuration of Controller.
     */
    func initialConfig() {
        self.txtUname.text = ""
        self.txtPassword.text = ""
    }
    
    /**
     This method is used to validate user input.
        - Returns: Return boolean value to indicate input data is valid or not.
     */
    
    func isValidUserInput() -> Bool {
        if txtUname.isEmpty {
            Utilities.showAlert(msg: Constant.ValidationMessage.kEmptyEmail, vc: self)
            return false
        }
        if !txtUname.isValidEmailField() {
            Utilities.showAlert(msg: Constant.ValidationMessage.kInvalidEmail, vc: self)
            return false
        }
        else if txtPassword.isEmpty {
            Utilities.showAlert(msg: Constant.ValidationMessage.kEmptyPasswoed, vc: self)
            return false
        }
        return true
    }
    
    //MARK : - Button click methods
    
    /**
     This method is used to handle login button click.
        - Parameter sender: action button
     */
    @IBAction func loginClick(_ sender: Any) {
        self.view.endEditing(true)        
        if isValidUserInput() {
            loginApi()
        }
    }
    
    /**
     This method is used to handle FB login button click.
        - Parameter sender: action button
     */
    @IBAction func fbLoginClick(_ sender: Any) {
        
        let fbManager: FBSDKLoginManager = FBSDKLoginManager()
        fbManager.logOut()
        
        //Call login method of FBSDK
        fbManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                //Handle the success response of FB Login
                let fbLoginResult : FBSDKLoginManagerLoginResult = result!
                if fbLoginResult.grantedPermissions != nil {
                    if(fbLoginResult.grantedPermissions.contains("email")) {
                        if((FBSDKAccessToken.current()) != nil) {
                            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                if (error == nil){
                                    let fbUserDict = result as! [String : AnyObject]
                                    //Saving user Data in Userdefault
                                    let fbLogin = UserDefaults.standard
                                    fbLogin.set(fbUserDict, forKey: Constant.UserDefaultsKey.AccFBLogin)
                                    UserDefaults.standard.set(true, forKey: Constant.UserDefaultsKey.IsLogin)

                                    //Redirect to Address List screen after successful login
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.setupRootView()
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - API call method
    /**
     This method is used to call login API.
     */
    func loginApi()  {
        
        //Set up dummy parameters for test api call
        var dictParam = [String : Any]()
        dictParam[RequestParamater.kEmail] = self.txtUname.text ?? ""
        dictParam[RequestParamater.kPassword] = self.txtPassword.text  ?? ""
        
        SVProgressHUD.show()
        APIManager.callURLStringJson(Constant.serverAPI.URL.Login, withRequest: dictParam, withSuccess: { (response) in
            
            //We are ignoring the response as make you login
            
            UserDefaults.standard.set(true, forKey: Constant.UserDefaultsKey.IsLogin)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setupRootView()
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            Utilities.showAlert(msg: error, vc: self)
            print(error)
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilities.showAlert(msg: err, vc: self)
            print(err)
        }
    }
}

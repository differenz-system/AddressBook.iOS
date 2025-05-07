//
//  LoginVC.swift
//  AddressBook
//
//  Created by DifferenzSystem PVT. LTD. on 01/19/2021.
//  Copyright © 2021 Differenz System. All rights reserved.
//

import UIKit
import SVProgressHUD
//import FBSDKLoginKit

class LoginVC: BaseView {
    
    //MARK: - IBoutlet
    @IBOutlet weak var txtUname: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
//    @IBOutlet weak var btnFb: FBLoginButton!
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwPassword: UIView!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.btnLogin.applyGradient()
    }
    //MARK : - Instance methods
    
    /**
     This method is used for initial configuration of Controller.
     */
    func initialConfig() {
        self.txtUname.text = ""
        self.txtPassword.text = ""
        self.imgBg.roundBottomCorners(radius: 30)
        self.vwEmail.backgroundColor = UIColor(white: 1, alpha: 0.3)
        self.vwPassword.backgroundColor = UIColor(white: 1, alpha: 0.3)
       
    }
    
    /**
     This method is used to validate user input.
        - Returns: Return boolean value to indicate input data is valid or not.
     */
    
    func isValidUserInput() -> Bool {
        if self.txtUname.isEmpty {
            Utilities.showAlert(msg: Constant.ValidationMessage.kEmptyEmail, vc: self)
            return false
        }
        if !self.txtUname.isValidEmailField() {
            Utilities.showAlert(msg: Constant.ValidationMessage.kInvalidEmail, vc: self)
            return false
        }
        else if self.txtPassword.isEmpty {
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
    @IBAction func btnLoginTouchUpInsite(_ sender: Any) {
        self.view.endEditing(true)        
        if self.isValidUserInput() {
            self.callLogin()
        }
    }
    
    /**
     This method is used to handle FB login button click.
        - Parameter sender: action button
     */
//    @IBAction func btnFacebookLoginTouchUpInsite(_ sender: Any) {
//        let fbManager: LoginManager = LoginManager()
//        fbManager.logOut()
//        
//        //Call login method of FBSDK
//        fbManager.logIn(permissions: ["email"], from: self) { (result, error) in
//            if (error == nil){
//                //Handle the success response of FB Login
//                let fbLoginResult : LoginManagerLoginResult = result!
//                    if(fbLoginResult.grantedPermissions.contains("email")) {
//                        if((AccessToken.current) != nil) {
//                            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
//                                if (error == nil){
//                                    let fbUserDict = result as! [String : AnyObject]
//                                   
//                                    //Saving user Data in Userdefault
//                                    let fbLogin = UserDefaults.standard
//                                    fbLogin.set(fbUserDict, forKey: Constant.UserDefaultsKey.AccFBLogin)
//                                    UserDefaults.standard.set(true, forKey: Constant.UserDefaultsKey.IsLogin)
//
//                                    //Redirect to Address List screen after successful login
//                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                    appDelegate.setupRootView()
//                                }
//                            })
//                        }
//                    }
//            }
//        }
//    }
    
    //MARK: - API call method
    /**
     This method is used to call login API.
     */
    func callLogin()  {
        
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

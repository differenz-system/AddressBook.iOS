//
//  Constant.swift
//  AddressBook
//
//  Created by MohiniPatel on 9/20/17.
//  Copyright © 2017 Differenz System. All rights reserved.
//

import UIKit

class Constant: NSObject {
    //MARK: - Device Constant
    enum UIUserInterfaceIdiom : Int
    {
        case Unspecified
        case Phone
        case Pad
    }
    //iPhone Screensize
    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    //iPhone devicetype
    struct DeviceType {
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
        static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    }
    
    //MARK: - API constants
    struct serverAPI {
    
        //MARK: - API URL constants
        struct URL {
            static let kBaseURL                  = "https://postman-echo.com/"
            
            static let Login                     = kBaseURL + "post"
            
        }
        
        //MARK: - API Error Message constants
        
        struct errorMessages {
            static let kNoInternetConnectionMessage     = "Please check your internet connection."
            static let kCommanErrorMessage              = "Something went wrong please try again later."
            static let kServerErrorMessage              = "There seems to be a problem with the connection. Please try again soon."
        }

    }
    
    //MARK: - Validation message constants
    
    struct ValidationMessage {
        static let kEmptyUserName                       = "Please enter username"
        static let kEmptyPasswoed                       = "Please enter password"
        static let kEmptyName                           = "Please enter name"
        static let kEmptyEmail                          = "Please enter email"
        static let kInvalidEmail                        = "Please enter valid email"
        static let kEmptyContactNo                      = "Please enter contact number"
        static let kInvalidContactNo                    = "Please enter valid contact number"
    }
    
    //MARK: - ViewController Identifier constants
    
    struct VCIdetinfier {
        static let LoginVC                              = "LoginVC"
        static let AddAddressVC                         = "AddAddressVC"
        static let AddressListVC                        = "AddressListVC"
    }
    
    //MARK: - UserDefaults key constants
    
    struct UserDefaultsKey {
        static let IsLogin                              = "isLogin"
        static let AccFBLogin                           = "accFBLogin"
    }
}

//MARK: - API Request Paramter constants
struct RequestParamater {
    static let kEmail                                   = "email"
    static let kPassword                                = "password"
}

//MARK: - API Response Paramter constants
struct ResponseParamater {
    static let kResult                                  = "Result"
    static let kErrors                                  = "Errors"
}


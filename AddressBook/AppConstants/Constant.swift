//
//  Constant.swift
//  AddressBook
//
//  Created by DifferenzSystem PVT. LTD. on 01/19/2021.
//  Copyright © 2021 Differenz System. All rights reserved.
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
    
    
    //MARK: - Color Constants
    struct AppColor
    {
        static let  ThemeColor   = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        static let  ThemeLightColor   = #colorLiteral(red: 0, green: 0.831372549, blue: 0.7098039216, alpha: 1)
        static let  ThemeDarkColor   = #colorLiteral(red: 0.1333333333, green: 0.3803921569, blue: 0.3803921569, alpha: 1)
        static let  BorderColor = #colorLiteral(red: 0.1843137255, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
        static let  ShadowColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        static let  gradiantColorOne = #colorLiteral(red: 0.6352941176, green: 0.8509803922, blue: 0.8078431373, alpha: 1)
        static let  gradiantColorTwo = #colorLiteral(red: 0.3921568627, green: 0.5921568627, blue: 0.6, alpha: 1)
        
    }
    
    struct TitleTextSize
    {
        static let  TextLargeSize   = UIFont.boldSystemFont(ofSize: DeviceType.IS_IPAD ? 28 : 24 )
        static let  TextMediusSize   = UIFont.systemFont(ofSize: DeviceType.IS_IPAD ? 22 : 16 , weight: UIFont.Weight(rawValue: 0.5))
        
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


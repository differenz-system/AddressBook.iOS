//
//  APIManager.swift
//  AwakenedMind
//
//  Created by mac on 6/2/17.
//  Copyright © 2017 Differenz System Pvt. Ltd. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import Alamofire


class APIManager: NSObject {
    //MARK: - Check for internet connection
    
    /**
     This method is used to check internet connectivity.
        - Returns: Return boolean value to indicate device is connected with internet or not
     */
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    //MARK: - Post method with content type application/json
    
    /**
     This method is used to make Alamofire post request with parameters.
        - Parameters:
            - URLString: URL of request
            - requestDictionary: Parameter of POST request
            - withSuccess: Success closure of method
            - responseDictionary: Response object of POST request
            - failure: Failure closure of method
            - error: Failure error
            - connectionFailed: Network connection faild closure of method
            - error: Network error
     */
    
    class func callURLStringJson(_ urlString: String, withRequest requestDictionary: [String: Any]?, withSuccess success: @escaping (_ responseDictionary: AnyObject) -> Void, failure: @escaping (_ error: String) -> Void, connectionFailed: @escaping (_ error: String) -> Void) {
        
        if(Utilities.checkInternetConnection()) {
            let url = URL(string:urlString)!
            print(url)
            
            do {
                //Make JSON string from request parameter
                let jsonData = try JSONSerialization.data(withJSONObject: requestDictionary ?? [:], options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString: String = String(data: jsonData, encoding: String.Encoding.utf8)!
                print(jsonString)
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            //Make alamofire POST request
            Alamofire.request(url, method: .post, parameters: requestDictionary ?? [:], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success:
                    let jsonString: String = String(data: response.data!, encoding: String.Encoding.utf8)!
                    print(jsonString)
                    
                    if response.response?.statusCode == 200 {
                        success(response.result.value! as AnyObject)
                    }
                    else {
                        let res = response.result.value! as AnyObject
                        let msg = res["Message"] as? String
                        if msg != nil {
                            failure(msg!)
                        }
                        else {
                            failure("")
                        }
                    }
                case .failure(let error):
                    print("Request failed with error: \(error.localizedDescription)")
                    failure(error.localizedDescription)
                }
            })
        }
        else
        {
            connectionFailed(Constant.serverAPI.errorMessages.kNoInternetConnectionMessage)
        }
    }
}

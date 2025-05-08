//
//  Auth.swift
//  ChatApp
//
//  Created by Elluminati on 19/12/17.
//  Copyright © 2017 Irshad. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthProvider {

    private static let _instance = AuthProvider()
    private init (){}

    static var Instance:AuthProvider {
        return _instance
    }

    private func logOut() -> Bool {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                return true
            } catch {
                return false
            }
        }
        return false
    }

    public func firebaseAuthentication() {
        let firebaseAuth = Auth.auth()
        //       if firebaseAuth.currentUser == nil {
        firebaseAuth.signIn(withCustomToken:  preferenceHelper.getAuthToken()) { user, error in
            if error == nil {
                print("Firebase authentication successfull...")
            } else {
                print(error ?? "Error in firebase authentication")
            }
        }
        //        }
    }

    func wsGenerateFirebaseAcessToken() {
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TYPE] = CONSTANT.TYPE_PROVIDER

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GENERATE_FIREBASE_ACCESS_TOKEN, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in
            if (error != nil) {} else {
                if Parser.isSuccess(response: response,data: data, andErrorToast: false) {
                    if response["firebase_token"] != nil {
                        if response["firebase_token"] as? String != "" {
                            let authToken = response["firebase_token"] as! String
                            preferenceHelper.setAuthToken(authToken)
                            // Firebase auth login
                            self.firebaseAuthentication()
                        }
                    }
                }
            }
        }
    }
}

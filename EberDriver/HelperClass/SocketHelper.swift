//
//  SocketHelper.swift
//  Eber
//
//  Created by Jaydeep Vyas  on 13.03.19.
//  Copyright © 2019 Elluminati. All rights reserved.
//

import Foundation
import SocketIO

class SocketHelper : NSObject {

    let manager = SocketManager(socketURL: URL(string:WebService.BASE_URL)!, config: [.log(false), .compress])
    var socket:SocketIOClient? = nil
    var blockCompletion: (([String:Any], _ error: Error?)->())!
    let locationEmit:String = "update_location"
    let tripDetailNotify:String = "trip_detail_notify"
    let get_new_trip: String = "get_new_request_"
    let paytabs:String = "paytabs_"
    let applePay:String = "applepay_" // 'applepay_" + user_id + '

    static let shared = SocketHelper()
    private override init() {}

    func connectSocket() {
        socket = manager.defaultSocket
        socket?.on(clientEvent: .connect) { (data, ack) in
//            print("Socket Connection Connected")
        }
        socket?.on(clientEvent: .error) { (data, ack) in
//            print("Socket Connection Error = \(data.description) and ack = \(ack.description)")
            self.disConnectSocket()
        }
        
        socket?.on(clientEvent: .pong) { (data, ack) in
//            print("Socket Connection Pong \(data) Ack \(ack)")
        }
        socket?.connect()
    }
    
    func disConnectSocket() {
        if self.socket?.status == .connected {
            print("Socket Connection disconnected")
            self.socket?.disconnect()
        }
    }
}

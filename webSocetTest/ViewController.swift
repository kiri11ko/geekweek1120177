//
//  ViewController.swift
//  webSocetTest
//
//  Created by Kirill Lukyanov on 20.09.17.
//  Copyright © 2017 Kirill Lukyanov. All rights reserved.
//

import UIKit
import SwiftWebSocket
import SwiftyJSON
import SQLite3


class ViewController: UIViewController, UITableViewDataSource {
        let ws = WebSocket("wss://bitlish.com/ws")
//     let ws = WebSocket("wss://api.bitfinex.com/ws")
    var ordersList: [String: String] = [:]
     var ordersListRates: [String: String] = [:]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

                        echoTest()
//        openDatabase()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
//    func openDatabase() -> OpaquePointer? {
//        let part1DbPath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil,create: false).appendingPathComponent("asd.db")
//        var db: OpaquePointer? = nil
//        if sqlite3_open(part1DbPath, &db) == SQLITE_OK {
//            print("Successfully opened connection to database at \(part1DbPath)")
//            return db
//        } else {
//            print("Unable to open database. Verify that you created the directory described " +
//                "in the Getting Started section.")
////            PlaygroundPage.current.finishExecution()
//        }
//
//    }
    
    
    func echoTest(){
        let send : ()->() = {
            let json = JSON(["call": "trades_depth", "data": ["pair_id": "btcusd"]])
            let data = try! json.rawData()
            self.ws.send(data: data)
            print("send")

        }
        ws.event.open = {
                    print("opened")
                    send()
        
        }
        ws.event.close = { code, reason, clean in
            print("close")
        }
        ws.event.error = { error in
            print("error \(error)")
        }

        ws.event.message = { message in
            
            let json = JSON(parseJSON: String(describing: message))
            print("JSON:",json)
            if json["call"].stringValue == "public_trade_order_create" {
                self.ordersList[json["data"]["order"]["id"].stringValue] = json["data"]["order"]["price"].stringValue
                print("orderID", json["data"]["order"]["id"].stringValue)
            } else if json["call"].stringValue == "public_trade_order_cancel"   {
                self.ordersList[json["data"]["order"]["id"].stringValue] = nil
            }
            if json["call"].stringValue == "public_trade_order_create" {
                self.ordersListRates[json["data"]["order"]["id"].stringValue] = json["data"]["order"]["pair_id"].stringValue
                print("orderID", json["data"]["order"]["id"].stringValue)
            } else if json["call"].stringValue == "public_trade_order_cancel"   {
                self.ordersListRates[json["data"]["order"]["id"].stringValue] = nil
            }
            self.tableView.reloadData()
//            let json = try! JSONDecoder().decode(JSONOrders.self, from: message as! Data)
//            print("json = \(json.call)")
//            print(json["call"].stringValue, json["data"])
            
        }
    }

    @IBAction func getData(_ sender: Any) {
        let send : ()->() = {

            let json = JSON(["type":"request","token":nil,"mark":"1456906008097043","data":nil,"call":"tickers"])
            let jsonPing = JSON(["event":"ping"])

            let data = try! json.rawData()
            self.ws.send(data: data)
            print("send \(json)")
//
        }
        send()
//        ws.event.error = { error in
//            print("error \(error)")
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Array(ordersList.values)[indexPath.row]
        cell.detailTextLabel?.text = Array(ordersListRates.values)[indexPath.row]
        return cell
    }
}


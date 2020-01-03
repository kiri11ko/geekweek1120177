//
//  NewViewController.swift
//  webSocetTest
//
//  Created by Kirill Lukyanov on 16.11.2017.
//  Copyright © 2017 Kirill Lukyanov. All rights reserved.
//

import UIKit
import SwiftWebSocket
import SwiftyJSON

class NewViewController: UIViewController {
    let ws = WebSocket("wss://bitlish.com/ws")
    
    @IBOutlet weak var tableView: UITableView!
    
    var pairIdList: [String] = []
    var minValueList: [String] = []
    var maxValueLIst: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        echoTest()
        print("test")
        // Do any additional setup after loading the view.
    }
    
    func echoTest(){
//        var messageNum = 0
        let send : ()->() = {
//            messageNum += 1
//            let msg = "\(messageNum): \(NSDate().description)"
//            print("send: \(msg)")
//            ws.send(msg)
        }
        ws.event.open = {
            print("opened")
//            send()
        }
        ws.event.close = { code, reason, clean in
            print("close")
        }
        ws.event.error = { error in
            print("error \(error)")
        }
        ws.event.message = { message in
            
//            print(message)
            let json = JSON(parseJSON: String(describing: message))
//            print("JSON:",json)
            if json["call"].stringValue == "tickers" {
                for (key, subJSON) in json["data"] {
                    self.pairIdList.append(key)
                    self.maxValueLIst.append(subJSON["max"].stringValue)
                    self.minValueList.append(subJSON["min"].stringValue)
                }
                self.tableView.reloadData()
            }
//            if let text = message as? String {
//                print("recv: \(text)")
//                if messageNum == 10 {
//                    ws.close()
//                } else {
//                    send()
//                }
//            }
            
            
        }
    }
    
    @IBAction func sendJSON(_ sender: Any) {
//        trades_history { "pair_id" : "btceur" }

        let historyRequest = JSON(["call": "trades_history", "data": ["pair_id": "btceur"]])
        let tickersRequest = JSON(["call": "tickers"])
//        ws.send(historyRequest)
        ws.send(tickersRequest)
        print(tickersRequest)
    }
    


}
extension NewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairIdList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = pairIdList[indexPath.row]
        cell.detailTextLabel?.text = "Max=\(maxValueLIst[indexPath.row]), min=\(minValueList[indexPath.row])"
        return cell
    }
}

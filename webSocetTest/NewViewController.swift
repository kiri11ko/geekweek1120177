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
<<<<<<< HEAD
        print("test")
        // Do any additional setup after loading the view.
=======
>>>>>>> fixible
    }
    
    func echoTest(){
        let send : ()->() = {
        }
        ws.event.open = {
            print("opened")
        }
        ws.event.close = { code, reason, clean in
            print("close")
        }
        ws.event.error = { error in
            print("error \(error)")
        }
        ws.event.message = { message in
            let json = JSON(parseJSON: String(describing: message))
            if json["call"].stringValue == "tickers" {
                for (key, subJSON) in json["data"] {
                    self.pairIdList.append(key)
                    self.maxValueLIst.append(subJSON["max"].stringValue)
                    self.minValueList.append(subJSON["min"].stringValue)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func sendJSON(_ sender: Any) {
        let historyRequest = JSON(["call": "trades_history", "data": ["pair_id": "btceur"]])
        let tickersRequest = JSON(["call": "tickers"])
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

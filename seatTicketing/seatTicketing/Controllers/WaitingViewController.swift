//
//  WaitingViewController.swift
//  seatTicketing
//
//  Created by 김수완 on 2020/08/13.
//  Copyright © 2020 김수완. All rights reserved.
//

import UIKit
import FirebaseDatabase

var now : Int = 0
var max : Int = 0

class WaitingViewController: UIViewController {
    
    var ref : DatabaseReference!

    @IBOutlet weak var usersLable: UILabel!
    @IBOutlet weak var usersMaxLable: UILabel!
    @IBOutlet weak var nowUsersLable: UILabel!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        ref.child(code+"/userNum/max").observeSingleEvent(of: .value) { snapshotMax in
            max = snapshotMax.value as? Int ?? 0
            self.usersMaxLable.text = String(max)
            self.UImakeup()
            
        }
        
        ref.observe(DataEventType.childChanged, with: { _ in
            
            self.UImakeup()
            
            self.ref.child(code+"/start").observeSingleEvent(of: .value) { snapshotStart in
                let start = snapshotStart.value as? Bool ?? false
                if start {
                    self.performSegue(withIdentifier: "start", sender: self)
                }
            }
        })
    }
    
    func UImakeup() {
        self.ref.child(code+"/userNum/now").observeSingleEvent(of: .value) { snapshotNow in
            now = snapshotNow.value as? Int ?? 0
            now = (max) - now
            self.nowUsersLable.text = String(now)
        }
        self.ref.child(code+"/userNames").observeSingleEvent(of: .value) { snapshotName in
            let names = snapshotName.value as? String ?? ""
            self.usersLable.text = names
        }
    }

}

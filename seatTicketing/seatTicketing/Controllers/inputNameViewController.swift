//
//  inputNameViewController.swift
//  seatTicketing
//
//  Created by 김수완 on 2020/08/13.
//  Copyright © 2020 김수완. All rights reserved.
//

import UIKit
import FirebaseDatabase

var userName : String = ""
var myName : String = ""

class inputNameViewController: UIViewController, UITextFieldDelegate {
    
    var ref : DatabaseReference!
    
    @IBOutlet weak var NameTextField: UITextField!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        super.viewDidLoad()
        
        NameTextField.delegate = self
    }
    
    @IBAction func NextBtn(_ sender: Any) {
        myName = NameTextField.text!
        
        if myName != "" {
            self.ref = Database.database().reference()
            self.ref.child(code+"/userNames").observeSingleEvent(of: .value) { snapshotName in
                let namesIn = snapshotName.value as? String ?? ""
                let namesOut = self.ref.child(code+"/userNames")
                namesOut.setValue(namesIn+myName+" ")
                self.ref.child(code+"/userNum/now").observeSingleEvent(of: .value) { snapshotNum in
                    let numIn = snapshotNum.value as? Int ?? 0
                    let numOut = self.ref.child(code+"/userNum/now")
                    numOut.setValue(numIn-1)
                }
                userName = namesIn
                self.performSegue(withIdentifier: "goWaitingView", sender: self)
            }
        }
        else {
            alert("이름을 입력해 주새요.")
        }
    }
    
    func alert(_ phrases : String) {
        let alert = UIAlertController(title: phrases, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          view.endEditing(true)
      }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

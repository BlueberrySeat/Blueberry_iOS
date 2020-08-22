//
//  inputCodeViewController.swift
//  seatTicketing
//
//  Created by 김수완 on 2020/08/13.
//  Copyright © 2020 김수완. All rights reserved.
//

import UIKit
import FirebaseDatabase

var code : String = ""

class inputCodeViewController: UIViewController, UITextFieldDelegate {
    
    var ref : DatabaseReference!

    @IBOutlet weak var CodeTextField: UITextField!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        super.viewDidLoad()
        
        CodeTextField.delegate = self
    }

    @IBAction func NextBtn(_ sender: Any) {
        
        code = CodeTextField.text!
        
        ref = Database.database().reference()
        ref.child(code+"/userNum/now").observeSingleEvent(of: .value) { snapshotNow in
            self.ref.child(code+"/start").observeSingleEvent(of: .value) { snapshotStart in
                let num = snapshotNow.value as? Int ?? 0
                let start = snapshotStart.value as? Bool ?? true
            
                if num > 0 && start == false{
                    self.performSegue(withIdentifier: "gotoInputName", sender: self)
                }
                else{
                    self.alert("코드번호를 확인해 주세요.")
                }
                
            }
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


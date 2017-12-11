//
//  Lock.swift
//  CampusNoteTest
//
//  Created by user on 2017. 11. 24..
//  Copyright © 2017년 user. All rights reserved.
//

import UIKit
import LocalAuthentication

class Lock: UIViewController {
  
        @IBOutlet weak var authentication: UILabel!
        @IBOutlet weak var resultLabel: UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            resultLabel?.text = ""
        }
        
        
        @IBAction func authenticationAction(_ sender: Any) {
            
            let alertController = UIAlertController(title: "Authentication",message: "Press TouchID ", preferredStyle: .actionSheet)
            
            let touchidAction = UIAlertAction(title: "Touch ID", style: .default,handler: {action in self.touchid_func()})
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(touchidAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        func touchid_func() {
            
            let context = LAContext()
            var error : NSError?
            if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Use your fingerprint", reply:
                    {success, error in
                        if success {
                            DispatchQueue.main.async {
                                self.resultLabel.text = "SUCCESS"
                            }
                        }
                        else {
                            
                            DispatchQueue.main.async {
                                self.resultLabel.text = "FAILED"
                            }
                        }
                })
            } else {
                resultLabel.text = "No Touch ID in the device"
                
            }
        }
    
        
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
}


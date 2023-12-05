//
//  ForgotViewController.swift
//  PlanYourTripWithCheero
//
//  Created by Supriya Bodapati on 11/1/2023.
//

import UIKit
import FirebaseAuth
import MBProgressHUD

class ForgotViewController: UIViewController {

    @IBOutlet var email: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func showMsg(msg: String) -> Void {
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func sendOTP(_ sender: Any) {
        
        self.view.endEditing(true)
        if self.validateData() {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Auth.auth().sendPasswordReset(withEmail: email.text!) { error in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                if let error = error {
                    
                    self.showMsg(msg: error.localizedDescription )
                    return
                }
                
                self.showMsg(msg: "Password reset link sent to given email")
            }
        }
    }
    
    func validateData() -> Bool {
        
        if email.text == "" {
            
            self.showMsg(msg: "Email is required")
            return false
        }
        
        return true
    }
    
}

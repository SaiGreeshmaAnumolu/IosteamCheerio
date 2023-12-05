//
//  ChangePasswordViewController.swift
//  PlanYourTripWithCheero
//
//  Created by Anudeep Yalamanchi on 11/3/2023.
//

import UIKit
import FirebaseAuth
import MBProgressHUD


class ChangePasswordViewController: UIViewController {

    @IBOutlet var password: UITextField!
    @IBOutlet var newPassword: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Change Password"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func update(_ sender: Any) {
        
        self.view.endEditing(true)
        if self.validateData() {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            if let user = Auth.auth().currentUser {
                let newPassword = newPassword.text!
                let currentPassword = password.text!

                // Create credentials with the user's current email and password
                let credential = EmailAuthProvider.credential(withEmail: user.email!, password: currentPassword)

                // Reauthenticate the user with the current credentials
                user.reauthenticate(with: credential) { (authResult, error) in
                    if let error = error {
                        // Reauthentication failed, handle the error
                        print("Reauthentication failed: \(error.localizedDescription)")
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.showMsg(msg: "Reauthentication failed: \(error.localizedDescription)")
                        
                        
                    } else {
                        // Reauthentication succeeded, now update the password
                        user.updatePassword(to: newPassword) { (error) in
                            if let error = error {
                                // Password update failed, handle the error
                                print("Password update failed: \(error.localizedDescription)")
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.showMsg(msg: "Password update failed: \(error.localizedDescription)")
                                
                            } else {
                                // Password update succeeded
                                print("Password updated successfully!")
                                MBProgressHUD.hide(for: self.view, animated: true)
                                
                                let alert = UIAlertController(title: "", message: "Password changed successfully", preferredStyle: .alert)
                                let ok = UIAlertAction(title: "Ok", style: .default, handler: { action in
                                    
                                    self.navigationController?.popViewController(animated: true)
                                })
                                alert.addAction(ok)
                                DispatchQueue.main.async(execute: {
                                    self.present(alert, animated: true)
                                })
                            }
                        }
                    }
                }
            }
            
        }
        
        
    }
    
    func showMsg(msg: String) -> Void {
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    func validateData() -> Bool {
        
        if password.text == "" {
            
            self.showMsg(msg: "Password is required")
            return false
        }else if newPassword.text == "" {
            
            self.showMsg(msg: "New Password is required")
            return false
        }else if confirmPassword.text == "" {
            
            self.showMsg(msg: "Confirm Password is required")
            return false
        }else if password.text == newPassword.text {
            
            self.showMsg(msg: "New Password must be changed from old password")
            return false
        }
        
        return true
    }
    
}

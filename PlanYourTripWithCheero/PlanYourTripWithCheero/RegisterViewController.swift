//
//  RegisterViewController.swift
//  PlanYourTripWithCheero
//
//  Created by Supriya Bodapati on 11/1/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MBProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    
    
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
    @IBAction func registerBtn(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if self.validateData() {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { authResult, error in
              
                if error != nil {
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.showMsg(msg: error?.localizedDescription ?? "")
                }else{
                    
                    let profile = authResult?.user.createProfileChangeRequest()
                    profile?.displayName = self.name.text!
                    profile?.commitChanges(completion: { error in
                        if error != nil {
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.showMsg(msg: error?.localizedDescription ?? "")
                        }else{
                            
                            Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { [weak self] authResult, error in
                              guard let strongSelf = self else { return }
                                print(strongSelf)
                              
                                MBProgressHUD.hide(for: self!.view, animated: true)
                                
                                let obj = self?.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                                self?.navigationController!.pushViewController(obj, animated: true)
                                
                            }
                        }
                    })
                }
            }
        }
    }

    
    func validateData() -> Bool {
        
        if name.text == "" {
            
            self.showMsg(msg: "Name is required")
            return false
        }else if email.text == "" {
            
            self.showMsg(msg: "Email is required")
            return false
        }else if password.text == "" {
            
            self.showMsg(msg: "Password is required")
            return false
        }else if confirmPassword.text == "" {
            
            self.showMsg(msg: "Confirm Password is required")
            return false
        }else if password.text != confirmPassword.text {
            
            self.showMsg(msg: "Password and Confirm Password not same")
            return false
        }
        
        return true
    }
    
}

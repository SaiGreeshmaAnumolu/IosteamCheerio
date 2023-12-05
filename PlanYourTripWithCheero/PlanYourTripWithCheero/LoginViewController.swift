//
//  LoginViewController.swift
//  PlanYourTripWithCheero
//
//  Created by Supriya Bodapati on 11/1/2023.
//

import UIKit
import FirebaseAuth
import MBProgressHUD


class LoginViewController: UIViewController {

    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func forgotBtn(_ sender: Any) {
        
        self.view.endEditing(true)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ForgotViewController") as! ForgotViewController
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    
    func showMsg(msg: String) -> Void {
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func loginBtn(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if self.validateData() {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { [weak self] authResult, error in
              guard let strongSelf = self else { return }
                print(strongSelf)
              
                MBProgressHUD.hide(for: self!.view, animated: true)
                
                if error == nil {
                    
                    let obj = self?.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self?.navigationController!.pushViewController(obj, animated: true)
                }else {
                    
                    self?.showMsg(msg: error?.localizedDescription ?? "")
                }
                

                
            }
        }
    }
    
    
    @IBAction func create(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    
    func validateData() -> Bool {
        
        if email.text == "" {
            
            self.showMsg(msg: "Email is required")
            return false
        }else if password.text == "" {
            
            self.showMsg(msg: "Password is required")
            return false
        }
        
        return true
    }
    
    
}


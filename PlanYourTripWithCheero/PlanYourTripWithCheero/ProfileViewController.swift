//
//  ProfileViewController.swift
//  PlanYourTripWithCheero
//
//  Created by Supriya Bodapati on 11/3/2023.
//

import UIKit
import FirebaseAuth
import SDWebImage
import MBProgressHUD

class ProfileViewController: UIViewController {

    @IBOutlet var profileIV: UIImageView!
    @IBOutlet var emailLbl: UILabel!
    
    @IBOutlet var name: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Profile"
        emailLbl.text = Auth.auth().currentUser?.email ?? ""
        name.text = Auth.auth().currentUser?.displayName ?? ""
        let imgURL = Auth.auth().currentUser?.photoURL?.absoluteString ?? ""
        
        profileIV.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "Profile"))
        
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
        
        if name.text == "" {
            
            self.showMsg(msg: "name is required")
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name.text ?? ""
        
        changeRequest?.commitChanges { (error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showMsg(msg: "Profile updated.")
        }
    }
    
    @IBAction func changePassword(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    
    func showMsg(msg: String) -> Void {
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

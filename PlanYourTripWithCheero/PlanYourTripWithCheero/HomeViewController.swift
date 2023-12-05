//
//  HomeViewController.swift
//  PlanYourTripWithCheero
//
//  Created by Supriya Bodapati on 11/3/2023.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Home"

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func optionsBtnClicked(_ sender: UIButton) {
        
        let index = sender.tag
        if index == 0 {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ItinerariesViewController") as! ItinerariesViewController
            self.navigationController!.pushViewController(obj, animated: true)
            
        }else if index == 1 {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MyItinerariesViewController") as! MyItinerariesViewController
            self.navigationController!.pushViewController(obj, animated: true)
            
        }else if index == 2 {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MyUpcommingViewController") as! MyUpcommingViewController
            self.navigationController!.pushViewController(obj, animated: true)
            
        }else if index == 3 {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MyHistoryViewController") as! MyHistoryViewController
            self.navigationController!.pushViewController(obj, animated: true)
            
        }else if index == 4 {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController!.pushViewController(obj, animated: true)
        }else {
            
            let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Yes", style: .default, handler: { action in
                
                do {
                    try Auth.auth().signOut()
                } catch {}
                 
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController!.pushViewController(obj, animated: true)
            })
            
            let cancel = UIAlertAction(title: "No", style: .default, handler: { action in
            })
            alert.addAction(cancel)
            alert.addAction(ok)
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
            })
            
        }
    }
    
    
}

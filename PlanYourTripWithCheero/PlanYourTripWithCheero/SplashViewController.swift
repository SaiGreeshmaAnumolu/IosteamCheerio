//
//  SplashViewController.swift
//  PlanYourTripWithCheero
//
//  Created by Sai Greeshma Anumolu on 11/1/2023.
//

import UIKit
import FirebaseAuth
import Lottie

class SplashViewController: UIViewController {

    @IBOutlet var animationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animationView.loopMode = .playOnce
        animationView.animationSpeed = 2
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            
            if Auth.auth().currentUser == nil {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController!.pushViewController(obj, animated: true)
            }else {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController!.pushViewController(obj, animated: true)
            }
            
            
           
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

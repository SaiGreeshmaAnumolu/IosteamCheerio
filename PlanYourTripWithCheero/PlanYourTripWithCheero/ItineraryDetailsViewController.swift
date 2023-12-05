//
//  ItineraryDetailsViewController.swift
//  PlanYourTripWithCheero
//
//  Created by Sai Greeshma Anumolu on 11/10/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MBProgressHUD
import CoreLocation

class ItineraryDetailsViewController: UIViewController {
    
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    
    @IBOutlet var typeLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    
    var iten: ItineraryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        titleLbl.text = iten?.title ?? ""
        descriptionLbl.text = iten?.description ?? ""
        
        let url = iten?.image ?? ""
        imgView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: ""))
        
        priceLbl.text = String(format: "%@$", iten?.price ?? "0")
        
        let start = iten?.start_date ?? Date()
        let end = iten?.end_date ?? Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yy"
        
        let start_str = dateFormatter.string(from: start)
        let end_str = dateFormatter.string(from: end)
        
        dateLbl.text = String(format: "%@ - %@", start_str, end_str)
        
        
        typeLbl.text = iten?.type ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func book(_ sender: Any) {
        
        
        let id = Auth.auth().currentUser?.uid
        let myTimeStamp = Date().timeIntervalSince1970
        
        let start = iten?.start_date ?? Date()
        let end = iten?.end_date ?? Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let start_str = dateFormatter.string(from: start)
        let end_str = dateFormatter.string(from: end)
        
        
        let params = ["user_id": id ?? "",
                      "id": iten?.id ?? "",
                      "title": iten?.title ?? "",
                      "price": iten?.price ?? "",
                      "type": iten?.type ?? "",
                      "start_date": start_str,
                      "end_date": end_str,
                      "description": iten?.description ?? "",
                      "image": iten?.image ?? "",
                      "timestamp": myTimeStamp
                      ]as [String : Any]


        let path = String(format: "%@", "History")
        let db = Firestore.firestore()

        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        db.collection(path).document().setData(params) { err in
            if let err = err {
                
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showMsg(msg: err.localizedDescription)

            } else {

                MBProgressHUD.hide(for: self.view, animated: true)
                
                let alert = UIAlertController(title: "", message: "Booking successfully", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive, handler: { action in

                    // do something like...
                    self.navigationController?.popViewController(animated: true)

                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func map(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "TypesViewController") as! TypesViewController
        
        self.navigationController!.pushViewController(obj, animated: true)
        
        //self.openGoogleMap()
    }
    
    func openGoogleMap() {
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            
            if let url = URL(string: "comgooglemaps-x-callback://?directionsmode=driving&radius=4000&type=shopping_mall") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            //Open in browser
            if let urlDestination = URL.init(string: "http://maps.google.com/maps?directionsmode=driving&radius=4000&type=shopping_mall") {
                
                print(urlDestination)
                
                UIApplication.shared.open(urlDestination)
            }
        }
    }
    
    
    
    
    func showMsg(msg: String) -> Void {
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

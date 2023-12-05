//
//  MyItinerariesViewController.swift
//  PlanYourTripWithCheero
//
//  Created by Anudeep Yalamanchi on 11/6/2023.
//

import UIKit
import FirebaseFirestore
import SDWebImage
import MBProgressHUD
import FirebaseAuth

class MyItinerariesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let database = Firestore.firestore()
    
    var itinerariesList: [ItineraryModel] = []
    
    @IBOutlet var itinerariesTV: UITableView!
    
    @IBOutlet var searchBar: UISearchBar!
    
    var filteredData: [ItineraryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itinerariesTV.delegate = self
        itinerariesTV.dataSource = self
        
        
        searchBar.delegate = self
        self.navigationItem.title = "Itineraries"
        // Do any additional setup after loading the view.
        
        //itinerariesTV.isEditing = true
        //itinerariesTV.isUserInteractionEnabled = true
        self.getAllItineraries()
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGesture.direction = .left // or .right depending on your needs
        itinerariesTV.addGestureRecognizer(swipeGesture)
        
        
    }
    
    
    @objc func handleSwipe () -> Void {
        
        self.itinerariesTV.isEditing = true
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func getAllItineraries() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let id = Auth.auth().currentUser?.uid ?? ""
        
        let docRef = database.collection("Itineraries")
            .whereField("user_id", isEqualTo: id)
        
        docRef.addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                
                print("Error getting documents: \(err)")
                MBProgressHUD.hide(for: self.view, animated: true)
                
            } else {
                
                self.itinerariesList.removeAll()
                MBProgressHUD.hide(for: self.view, animated: true)
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let data = document.data()
                    
                    var itinerary = ItineraryModel()
                    itinerary.id = document.documentID
                    itinerary.image = data["image"] as? String ?? ""
                    itinerary.title = data["title"] as? String ?? ""
                    itinerary.price = data["price"] as? String ?? ""
                    itinerary.type = data["type"] as? String ?? ""
                    
                    let a = data["start_date"] as? String ?? ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    itinerary.start_date = dateFormatter.date(from: a)
                    
                    
                    let b = data["end_date"] as? String ?? ""
                    itinerary.end_date = dateFormatter.date(from: b)
                    
                    itinerary.description = data["description"] as? String ?? ""
                    
                    
                    self.itinerariesList.append(itinerary)
                    
                    
                }
                
                self.filteredData = self.itinerariesList
                self.itinerariesTV.reloadData()
            }
        }
    }

    
    func deleteItinerary(id: String) -> Void {
        
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this itinerary?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            self.itinerariesTV.isEditing = false
            self.delete(id: id)
        })
        
        let cancel = UIAlertAction(title: "No", style: .default, handler: { action in
        })
        alert.addAction(cancel)
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    
    func delete(id: String) -> Void {
        
        let db = Firestore.firestore()

        let docRef = db.collection("Itineraries").document(id)
        docRef.delete() { err in
            if let err = err {
                
                self.showMsg(msg: err.localizedDescription)
            } else {
                
                self.getAllItineraries()
            }
        }
        
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
    
    
    @IBAction func addBtnClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "add", sender: self)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ItineraryTVC! = tableView.dequeueReusableCell(withIdentifier: "ItinerariesCell") as? ItineraryTVC
        
        let iten = self.filteredData[indexPath.row]
        
        cell.titleLbl.text = iten.title ?? ""
        cell.descLbl.text = iten.description ?? ""
        
        let url = iten.image ?? ""
        cell.imgView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: ""))
        
        cell.priceLbl.text = String(format: "%@$", iten.price ?? "0")

        let start = iten.start_date ?? Date()
        let end = iten.end_date ?? Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yy"
        
        let start_str = dateFormatter.string(from: start)
        let end_str = dateFormatter.string(from: end)
        
        
        cell.dateLbl.text = String(format: "%@ - %@", start_str, end_str)
        
        return cell
        
    }
    
    // Enable editing for the table view
       func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           return true
       }

       // Set the editing style to delete
       func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
           return .delete
       }

       // Handle the commit editing style
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               
               let iten = self.filteredData[indexPath.row]
               self.deleteItinerary(id: iten.id ?? "")
               //filteredData.remove(at: indexPath.row)
               
               //tableView.deleteRows(at: [indexPath], with: .fade)
           }
       }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //self.itinerariesTV.isEditing = false
        //tableView.reloadData()
    }
}




extension MyItinerariesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData.removeAll()
        if searchText == "" {
            
            filteredData = self.itinerariesList
        }else {
            
            filteredData = itinerariesList.filter({ $0.title!.lowercased().contains(searchText.lowercased())})
        }
        
        self.itinerariesTV.reloadData()
    }
}

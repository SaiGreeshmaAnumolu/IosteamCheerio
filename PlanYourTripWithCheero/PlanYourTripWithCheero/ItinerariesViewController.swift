//
//  ItinerariesViewController.swift
//  PlanYourTripWithCheero
//
//  Created by Supriya Bodapati on 11/6/2023.
//

import UIKit
import FirebaseFirestore
import SDWebImage
import MBProgressHUD
import FirebaseAuth

class ItinerariesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let database = Firestore.firestore()
    
    var itinerariesList: [ItineraryModel] = []
    
    @IBOutlet var itinerariesTV: UITableView!
    
    @IBOutlet var searchBar: UISearchBar!
    
    var filteredData: [ItineraryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        self.navigationItem.title = "Itineraries"
        // Do any additional setup after loading the view.
        
        self.getAllItineraries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func getAllItineraries() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let id = Auth.auth().currentUser?.uid ?? ""
        
        let docRef = database.collection("Itineraries")
            .whereField("user_id", isNotEqualTo: id)
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

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
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

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ItineraryDetailsViewController") as! ItineraryDetailsViewController
        
        let iten = self.filteredData[indexPath.row]
        obj.iten = iten
        
        self.navigationController!.pushViewController(obj, animated: true)
    }
}




extension ItinerariesViewController: UISearchBarDelegate {
    
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

//
//  MyHistoryViewController.swift
//  PlanYourTripWithCheero
//
//  Created by Sai Greeshma Anumolu on 11/6/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MBProgressHUD

class MyHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var historyTV: UITableView!
    
    let database = Firestore.firestore()
    
    var HistoryList: [HistoryModel] = []
    var allRecords: [HistoryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        historyTV.delegate = self
        historyTV.dataSource = self
        
        self.getHistory()
        
        self.navigationItem.title = "History"
        // Do any additional setup after loading the view.
    }
    
    
    func getHistory() -> Void {
        
        let id = Auth.auth().currentUser?.uid ?? ""
        let docRef = database.collection("History")
            .whereField("user_id", isEqualTo: id)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        docRef.addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                
                MBProgressHUD.hide(for: self.view, animated: true)
                print("Error getting documents: \(err)")
                
                
            } else {
                
                self.allRecords.removeAll()
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let data = document.data()
                    
                    var his = HistoryModel()
                    his.user_id = data["user_id"] as? String ?? ""
                    his.id = data["id"] as? String ?? ""
                    his.image = data["image"] as? String ?? ""
                    his.title = data["title"] as? String ?? ""
                    his.price = data["price"] as? String ?? ""
                    his.type = data["type"] as? String ?? ""
                    
                    let a = data["start_date"] as? String ?? ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    his.start_date = dateFormatter.date(from: a)
                    
                    
                    let b = data["end_date"] as? String ?? ""
                    his.end_date = dateFormatter.date(from: b)
                    
                    his.description = data["description"] as? String ?? ""
                    
                    let t = data["timestamp"] as? Double ?? 0.0
                    let date = Date(timeIntervalSince1970: t)
                    
                    his.date = date
                    
                    self.allRecords.append(his)
                }
                
                for record in self.allRecords {
                    
                    let date = record.end_date ?? Date()
                    if date <= Date() {
                        
                        self.HistoryList.append(record)
                    }
                }
                
                
                self.historyTV.reloadData()
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
        return self.HistoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: HistoryTVC! = tableView.dequeueReusableCell(withIdentifier: "historyCell") as? HistoryTVC
        
        let iten = self.HistoryList[indexPath.row]
        
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
        
    }

}

//
//  TypesViewController.swift
//  PlanYourTripWithCheero
//
//  Created by Anudeep Yalamanchi on 11/20/2023.
//

import UIKit

class TypesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var types: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.navigationItem.title = "Types"
        self.navigationController?.navigationBar.isHidden = false
        types = ["Gas Station", "Restaurant", "Cafe", "Hospital", "Pharmacy", "Bank", "Supermarket", "Shopping Mall", "Airport", "Train Station", "Other"]
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return types.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = types[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let type = types[indexPath.row]
        var str = type.lowercased()
        str = str.replacingOccurrences(of: " ", with: "_")
        
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        obj.type = str
        self.navigationController!.pushViewController(obj, animated: true)
        
    }

}

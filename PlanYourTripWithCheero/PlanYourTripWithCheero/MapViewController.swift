//
//  MapViewController.swift
//  PlanYourTripWithCheero
//
//  Created by Sai Greeshma Anumolu on 11/20/2023.
//

import UIKit
import WebKit

class MapViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        spinner.isHidden = true
        self.navigationItem.title = "Map"
        self.navigationController?.navigationBar.isHidden = false
        webView.navigationDelegate = self
        loadGoogleMaps()
    }
    
    func loadGoogleMaps() {
        // Construct the Google Maps URL with hospital places
        if type == "other" {
            
            type = ""
        }
        
        let googleMapsURL = String(format: "https://www.google.com/maps/search/?api=1&query=%@", type)
        
        // Load the URL in the WKWebView
        if let url = URL(string: googleMapsURL) {
            let request = URLRequest(url: url)
            webView.load(request)
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

}


extension MapViewController: WKNavigationDelegate, WKUIDelegate{
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        spinner.isHidden = false
        spinner.startAnimating()
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        spinner.isHidden = true
        spinner.stopAnimating()
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinner.isHidden = true
        spinner.stopAnimating()
    }
        
}

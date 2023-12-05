//
//  AddItineraryViewController.swift
//  PlanYourTripWithCheero
//
//  Created by Anudeep Yalamanchi on 12/1/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import MBProgressHUD


class AddItineraryViewController: UIViewController {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var editBtn: UIButton!
    
    
    @IBOutlet var titleTF: UITextField!
    @IBOutlet var priceTF: UITextField!
    @IBOutlet var startDP: UIDatePicker!
    @IBOutlet var startDateTF: UITextField!
    @IBOutlet var endDP: UIDatePicker!
    @IBOutlet var endDateTF: UITextField!
    
    @IBOutlet var descTV: UITextView!
    
    
    @IBOutlet var familyBtn: UIButton!
    @IBOutlet var coupleBtn: UIButton!
    @IBOutlet var singleBtn: UIButton!
    
    var imageURL = ""
    var selectedImage: UIImage?
    var tripType = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDP.minimumDate = Date()
        
        descTV.text = "Write description"
        descTV.textColor = .lightGray
        descTV.delegate = self
        descTV.layer.cornerRadius = 8
        descTV.layer.borderWidth = 1
        descTV.layer.borderColor = UIColor.opaqueSeparator.cgColor
        
        imgView.layer.cornerRadius = imgView.frame.size.height / 2
        imgView.clipsToBounds = true
        self.navigationItem.title = "Add Itinerary"
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
    
    @IBAction func typeBtnClicked(_ sender: UIButton) {
        
        familyBtn.setImage(UIImage(named: "RadioUnChecked"), for: .normal)
        coupleBtn.setImage(UIImage(named: "RadioUnChecked"), for: .normal)
        singleBtn.setImage(UIImage(named: "RadioUnChecked"), for: .normal)
        
        if sender.tag == 1 {
            
            tripType = "Family"
            familyBtn.setImage(UIImage(named: "RadioChecked"), for: .normal)
        }else if sender.tag == 2 {
            
            tripType = "Couple"
            coupleBtn.setImage(UIImage(named: "RadioChecked"), for: .normal)
        }else if sender.tag == 3 {
            
            tripType = "Single"
            singleBtn.setImage(UIImage(named: "RadioChecked"), for: .normal)
        }
    }
    
    
    @IBAction func imgBtnClicked(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
            
            self.selectImageFromGallery()
            
            
        }))

        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            
            self.takeImageFromCamera()
            
            
        }))

        self.present(actionSheet, animated: true)
    }
    
    
    func selectImageFromGallery() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        self.present(pickerController, animated: true)
    }

    func takeImageFromCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        self.present(imagePicker, animated: true)
    }
    
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        
        if self.validateData() {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.uploadProfileImage {
                
                self.saveItinerary()
            }
        }
        
    }
    
    func saveItinerary() -> Void {
        
        let id = Auth.auth().currentUser?.uid ?? ""
        
        let start = startDP.date
        let end = endDP.date
        
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "dd/MM/yyyy"
        
        let start_str = dtFormatter.string(from: start)
        let end_str = dtFormatter.string(from: end)
        
        let params = ["user_id": id,
                      "title": titleTF.text!,
                      "price": String(format: "%@", priceTF.text!),
                      "image": imageURL,
                      "start_date": start_str,
                      "end_date": end_str,
                      "description": descTV.text!,
                      "type": tripType]
        

        let path = String(format: "%@", "Itineraries")
        let db = Firestore.firestore()

        db.collection(path).document().setData(params) { err in
            if let err = err {

                MBProgressHUD.hide(for: self.view, animated: true)
                self.showMsg(msg: err.localizedDescription)

            } else {

                MBProgressHUD.hide(for: self.view, animated: true)
                let alert = UIAlertController(title: "", message: "Itinerary added successfully", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive, handler: { action in

                    // do something like...
                    self.navigationController?.popViewController(animated: true)

                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    
    func uploadProfileImage(completion: @escaping () -> ()) {
        
        var imageData:Data = selectedImage!.pngData()! as Data
        if imageData.count <= 0 {
            
            imageData = selectedImage!.jpegData(compressionQuality: 1.0)! as Data
        }
        
        let uid = UUID()
        let name = "\(uid).png"
        
        let storageRef = Storage.storage().reference().child("\(name)")
        
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                print("error")
                MBProgressHUD.hide(for: self.view, animated: true)
                completion()
                
            } else {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                
                storageRef.downloadURL(completion: { (url, error) in
                    
                    let str = url?.absoluteString
                    self.imageURL = str ?? ""
                    completion()
                })
            }
        }
    }
    
    
    
    func validateData() -> Bool {
        
        if selectedImage == nil {
            
            self.showMsg(msg: "Image is required")
            return false
        }else if titleTF.text == "" {
            
            self.showMsg(msg: "Title is required")
            return false
        }else if priceTF.text == "" {
            
            self.showMsg(msg: "Price is required")
            return false
        }else if descTV.text == "Write description" {
            
            self.showMsg(msg: "Description is required")
            return false
        }else if tripType == "" {
            
            self.showMsg(msg: "Trip type is required")
            return false
        }
        
        return true
    }
    
    
    func showMsg(msg: String) -> Void {
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


extension AddItineraryViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage

        if let image = image {
            
            self.imgView.image = image
            self.selectedImage = image
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


extension AddItineraryViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = "Write description"
            textView.textColor = .lightGray
        }
    }
}

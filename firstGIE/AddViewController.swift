import UIKit
import Firebase
import FirebaseStorage
import SwiftUI
import XCTest

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet weak var pictureImage: UIImageView!
    
    var me: AppUser!
    var database: Firestore!
    var imagepicker: UIImagePickerController!
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: { (action) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType  = .camera
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        let photoLibraryAction = UIAlertAction(title: "フォトライブラリー", style: .default, handler: {(action) in
            
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    })
        alertController.addAction(photoLibraryAction)
}
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        alertController.popoverPresentationController?.sourceView = view

        present(alertController, animated: true, completion: nil)
}

    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        pictureImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true,completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.dataDetectorTypes = .link
        
        //setupTextView()
        database = Firestore.firestore()
        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tapGR.cancelsTouchesInView = false
                self.view.addGestureRecognizer(tapGR)
        
    }
    @objc func dismissKeyboard() {
            self.view.endEditing(true)
        }
    
    @IBAction func postContent() {
        let content = contentTextView.text!
        let saveDocument = database.collection("posts").document()
        saveDocument.setData([
            "content": content,
            "postID": saveDocument.documentID,
            "senderID": me.userID,
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
            
        ]) { error in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    // 前の画面に戻るボタン
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
    
    //@IBAction func addimage() {
       // present(imagepicker, animated: true)
}

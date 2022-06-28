import UIKit
import Firebase

class AddViewController: UIViewController {
    
    @IBOutlet var contentTextView: UITextView!

    var me: AppUser!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func setupTextView() {
        let toolBar = UIToolbar() // キーボードの上に置くツールバーの生成
        let flexibleSpaceBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // 今回は、右端にDoneボタンを置きたいので、左に空白を入れる
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard)) // Doneボタン
        toolBar.items = [flexibleSpaceBarButton, doneButton] // ツールバーにボタンを配置
        toolBar.sizeToFit()
        contentTextView.inputAccessoryView = toolBar // テキストビューにツールバーをセット
    }

    // キーボードを閉じる処理。
    @objc func dismissKeyboard() {
        contentTextView.resignFirstResponder()
    }
    
    @IBAction func postContent() {
        let content = contentTextView.text!
        let saveDocument = Firestore.firestore().collection("posts").document()
        saveDocument.setData([
            "content": content,
            "postID": saveDocument.documentID,
            "senderID": user.uid,
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]) { error in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

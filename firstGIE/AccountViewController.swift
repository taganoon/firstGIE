import UIKit
import Firebase

class AccountViewController: UIViewController {
    
    var auth: Auth!
    var me: AppUser!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        //userNameTextField.text = me.userName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if auth.currentUser != nil {
            auth.currentUser?.reload(completion: { error in
                if error == nil {
                    if self.auth.currentUser?.isEmailVerified == true {
                        self.performSegue(withIdentifier: "Timeline", sender: self.auth.currentUser!)
                    } else if self.auth.currentUser?.isEmailVerified == false {
                        let alert = UIAlertController(title: "確認用メールを送信しているので確認をお願いします。", message: "まだメール認証が完了していません。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Timeline" {
            let nextViewController = segue.destination as! TimelineViewController
            let user = sender as! User
            nextViewController.me = AppUser(data: ["userID": user.uid])
            nextViewController.me = AppUser(data: ["userName": user.uid])
            
        }
    }
    //func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder() // キーボードを閉じる
        //return true
    //}
    //@IBAction func save() {
        //let newUserName = userNameTextField.text!
        //Firestore.firestore().collection("users").document(me.userID).setData([
            //"userName": newUserName
        //], merge: true)
        //{ error in
            //if error == nil {
                //self.dismiss(animated: true, completion: nil) // errorがなく、正常に終了していたらタイムラインの画面に戻る
           // }
        //}
    
    @IBAction func registerAccount() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let newUserName = userNameTextField.text!
        //Firestore.firestore().collection("users").document(me.userID).setData([
            //"userName": newUserName
        //], merge: true)
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if error == nil, let result = result {
                result.user.sendEmailVerification(completion: { (error) in
                    if error == nil {
                        let alert = UIAlertController(title: "仮登録を行いました。", message: "入力したメールアドレス宛に確認メールを送信しました。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{
                            action in
                            self.navigationController?.popViewController(animated: true)
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            } else {
                print(error)
            }
        }
    }
}

// デリゲートメソッドは可読性のためextensionで分けて記述します。
extension AccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
}

import UIKit
import Firebase 

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    var me: AppUser!
    var database: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        database = Firestore.firestore() //
        tableView.delegate = self  // 追加
        tableView.dataSource = self
    }
    database.collection("users").document(me.userID).setData([
           "userID": me.userID
           ], merge: true)
   }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return postArray.count
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = postArray[indexPath.row].content
            return cell
    }
    @IBAction func toAddViewController() {
        performSegue(withIdentifier: "Add", sender: me)
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AddViewController // segue.destinationで遷移先のViewControllerが取得可能。
            destination.me = (sender as! AppUser)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        database.collection("posts").getDocuments { (snapshot, error) in
            if error == nil, let snapshot = snapshot {
                self.postArray = []
                for document in snapshot.documents {
                    let data = document.data()
                    let post = Post(data: data)
                    self.postArray.append(post)
                }
                self.tableView.reloadData() // 先ほど書いたprint文をこちらに変更
            }
        }
    }
}

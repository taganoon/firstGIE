import UIKit
import Firebase 

class TimelineViewController: UIViewController {

    var me: AppUser!
    var database: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        database = Firestore.firestore() //
    }
    @IBAction func toAddViewController() {
        performSegue(withIdentifier: "Add", sender: me)
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AddViewController // segue.destinationで遷移先のViewControllerが取得可能。
            destination.me = (sender as! AppUser)
    }
}

//
//  UserViewController.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/21.
//

import UIKit

class UserViewController: UIViewController {
    let PORT = Bundle.main.object(forInfoDictionaryKey: "PORT") as? String ?? ""
    let HOST = Bundle.main.object(forInfoDictionaryKey: "HOST") as? String ?? ""
    @IBOutlet weak var tfUser: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tfUser.text = HOST + PORT + "/user/user"
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

}

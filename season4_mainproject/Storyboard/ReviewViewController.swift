//
//  ReviewViewController.swift
//  season4_mainproject
//
//  Created by Kang Hyeon Oh on 2023/09/25.
//
import Cosmos
import UIKit

class ReviewViewController: UIViewController {



    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var ImgView: UIImageView!
    @IBOutlet weak var lblRelaese: UILabel!

    @IBOutlet weak var tfReview: UITextField!
    var receivedId: Int = 0

    // 별점 기능
    @IBOutlet weak var cosmosView: CosmosView!
    //https://velog.io/@minji0801/iOSLibrary-Cosmos#cocoapods

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = String(receivedId)
        cosmosView.rating = 4
        cosmosView.settings.updateOnTouch = false
        cosmosView.settings.starSize = 30
        cosmosView.settings.starMargin = 5
        cosmosView.settings.filledColor = UIColor.orange
        cosmosView.settings.emptyBorderColor = UIColor.orange
        cosmosView.settings.filledBorderColor = UIColor.orange
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
    @IBAction func btnCheck(_ sender: UIButton) {
    }

    @IBAction func btnSave(_ sender: UIButton) {
    }






    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
/*
    // MARK: -EXTENSION
 */

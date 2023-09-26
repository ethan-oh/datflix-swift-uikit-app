//
//  ReviewViewController.swift
//  season4_mainproject
//
//  Created by Kang Hyeon Oh on 2023/09/25.
//
import Cosmos
import UIKit

class ReviewViewController: UIViewController {
    
    let aicontroller = AIController(service: AiService())

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var ImgView: UIImageView!
    @IBOutlet weak var lblRelease: UILabel!
    
    @IBOutlet weak var tfReview: UITextField!
    var receivedId: Int = 0
    var receivedTitle: String = ""
    var receivedGenre: String = ""
    var receivedCountry: String = ""
    var imagePath: String = ""
    var receivedRelease: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = receivedTitle
        lblGenre.text = receivedGenre
        lblCountry.text = receivedCountry
        lblRelease.text = receivedRelease
        urlImage(imagePath)
        // Do any additional setup after loading the view.
    }
    
    func urlImage(_ imagePath: String) {
        let imageUrl = URL(string: imagePath)

        // 이미지 다운로드는 백그라운드 스레드에서 수행
        DispatchQueue.global().async {
            if let imageUrl = imageUrl, let imageData = try? Data(contentsOf: imageUrl), let image = UIImage(data: imageData) {
                // 이미지 크기 조정
                let imageSize = CGSize(width: 70, height: 100) // 원하는 크기로 조절
                UIGraphicsBeginImageContext(imageSize)
                image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
                if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
                    // UI 업데이트는 메인 스레드에서 수행
                    DispatchQueue.main.async { [weak self] in
                        self?.ImgView.image = resizedImage
                    }
                }
                UIGraphicsEndImageContext()
                // 이제 이미지 크기 조정 코드가 정상적으로 동작합니다.
            }
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
    @IBAction func btnCheck(_ sender: UIButton) {
        var result : String = "Dummy"
        aicontroller.aiResultMessage(review: tfReview.text!) { message in
            result = message
        }
        let resultAlert = UIAlertController(title: "댓글 AI 측정", message: "\(result)", preferredStyle: .alert)
        let OKACTION = UIAlertAction(title: "OK", style: .default, handler: { ACTION in self.navigationController?.popViewController(animated: true) })
        resultAlert.addAction(OKACTION)
        present(resultAlert, animated: true)

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

//
//  ViewController.swift
//  ScrollView
//
//  Created by 박지환 on 2023/09/22.
//

import UIKit

class ViewController: UIViewController {

    let contentArray = ["아오 어려워", "뭐가 이리 많은거야", "확인하는 용도"]
    
    
    
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 셀 리소스 파일 가져오기
        let myTableViewCellNib = UINib(nibName: String(describing: MyTableViewCell.self), bundle: nil)
        
        // 셀에 리소스 등록
        self.myTableView.register(myTableViewCellNib, forCellReuseIdentifier: "myTableViewCell")
        
        self.myTableView.rowHeight = UITableView.automaticDimension
        self.myTableView.estimatedRowHeight = 120
        
        // 아주 중요
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        print("contentArray.count : \(contentArray.count)")
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

extension ViewController: UITableViewDelegate{
    
}


extension ViewController: UITableViewDataSource {
    
    // 테이블 뷰 셀의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(3, self.contentArray.count)
    }
    // 각 셀에 대한 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myTableViewCell", for: indexPath) as! MyTableViewCell
        
        cell.userContentLabel.text = contentArray[indexPath.row]
        
        return cell
    }
    
    
}




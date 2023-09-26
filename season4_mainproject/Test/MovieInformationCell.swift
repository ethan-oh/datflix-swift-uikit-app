//
//  File.swift
//  season4_mainproject
//
//  Created by 박지환 on 2023/09/25.
//

import Foundation
import UIKit

class MovieInformationCell: UITableViewCell {
    //셀이 랜더링(그릴때) 될때
    @IBOutlet weak var userContentLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    var stateNumber = 0
    var isFullTextVisible = false
    var movie: [MovieDetailModel]?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        userContentLabel.numberOfLines = 0
        userContentLabel.lineBreakMode = .byWordWrapping
        guard let cell = sender.superview?.superview as? MovieInformationCell,
              let tableView = self.superview as? UITableView,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        isFullTextVisible.toggle()
        
        if isFullTextVisible {
            // 전체 내용 표시 로직
            userContentLabel.numberOfLines = 0 // 여러 줄 표시 허용
            userContentLabel.text = movie![indexPath.row].summary
            moreButton.setTitle("간략히", for: .normal)
        } else {
            // 간략 내용 표시 로직
            userContentLabel.numberOfLines = 6 // 원하는 줄 수로 설정
            userContentLabel.text = movie![indexPath.row].summary
            moreButton.setTitle("더보기", for: .normal)
        }
        
        if let tableView = superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}

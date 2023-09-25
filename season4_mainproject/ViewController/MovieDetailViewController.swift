//
//  MovieDetailViewController.swift
//  season4_mainproject
//
//  Created by 박지환 on 2023/09/25.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var reviewList: [Review] = []

    let contentArray = ["아오 어려워아오 어려워아오 어려워아오 어려워아오 어려워아오 어려워아오"]
    let contentArray2 = ["아오 어려워", "뭐가 이리 많은거야", "확인하는 용도"]

    let reviewController = ReviewController(service: ReviewService())

    @IBOutlet weak var Star_with_Comment_TableView: UITableView!
    @IBOutlet weak var Movie_Information_TableView: UITableView!
    @IBOutlet weak var MovieCast_TableView: UITableView!
    @IBOutlet weak var CommentTableView: UITableView!

    var receivedid: Int = 0


    @IBOutlet weak var Movie_Information_TableViewHeight: NSLayoutConstraint!



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 셀 리소스 파일 가져오기
        let Star_with_CommentViewCellNib = UINib(nibName: String(describing: Star_with_CommentCell.self), bundle: nil)

        // 셀에 리소스 등록
        self.Star_with_Comment_TableView.register(Star_with_CommentViewCellNib, forCellReuseIdentifier: "Star_with_CommentCell")

        self.Star_with_Comment_TableView.rowHeight = UITableView.automaticDimension
        self.Star_with_Comment_TableView.estimatedRowHeight = 120

        // 아주 중요
        self.Star_with_Comment_TableView.delegate = self
        self.Star_with_Comment_TableView.dataSource = self

        // 셀 리소스 파일 가져오기
        let MovieInformationViewCellNib = UINib(nibName: String(describing: MovieInformationCell.self), bundle: nil)

        // 셀에 리소스 등록
        self.Movie_Information_TableView.register(MovieInformationViewCellNib, forCellReuseIdentifier: "MovieInformationCell")

        self.Movie_Information_TableView.rowHeight = UITableView.automaticDimension
        self.Movie_Information_TableView.estimatedRowHeight = 120

        // 아주 중요
        self.Movie_Information_TableView.delegate = self
        self.Movie_Information_TableView.dataSource = self

        self.Movie_Information_TableView.rowHeight = UITableView.automaticDimension
        self.Movie_Information_TableView.estimatedRowHeight = 120


        // 셀 리소스 파일 가져오기
        let MovieCastCellNib = UINib(nibName: String(describing: MovieCastCell.self), bundle: nil)

        // 셀에 리소스 등록
        self.MovieCast_TableView.register(MovieCastCellNib, forCellReuseIdentifier: "MovieCastCell")

        self.MovieCast_TableView.rowHeight = UITableView.automaticDimension
        self.MovieCast_TableView.estimatedRowHeight = 120

        // 아주 중요
        self.MovieCast_TableView.delegate = self
        self.MovieCast_TableView.dataSource = self



        let CommentViewCellNib = UINib(nibName: String(describing: MyTableViewCell.self), bundle: nil)

        // 셀에 리소스 등록
        self.CommentTableView.register(CommentViewCellNib, forCellReuseIdentifier: "myTableViewCell")

        self.CommentTableView.rowHeight = UITableView.automaticDimension
        self.CommentTableView.estimatedRowHeight = 120

        // 아주 중요
        self.CommentTableView.delegate = self
        self.CommentTableView.dataSource = self

        print("contentArray.count : \(contentArray.count)")

        // Do any additional setup after loading the view.

    }

    override func viewWillAppear(_ animated: Bool) {
        readValues()
    }

    func readValues() {
        self.reviewList.removeAll()
        reviewController.selectReview(movie_id: self.receivedid) { [weak self] reviews in
            guard let self = self else { return }

            // 가져온 리뷰 데이터를 reviewList에 추가
            self.reviewList.append(contentsOf: reviews)

            // UI 업데이트는 메인 스레드에서 수행
            DispatchQueue.main.async {
                self.CommentTableView.reloadData()
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

}
extension MovieDetailViewController: UITableViewDelegate {

}

extension MovieDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == CommentTableView {
            // CommentTableView의 경우 contentArray.count로 셀의 갯수를 설정
            if reviewList.isEmpty {
                return 1
            } else {
                return reviewList.count // reviewList의 개수 반환
            }
        } else if tableView == Movie_Information_TableView {
            // Movie_Information_TableView의 경우 contentArray.count로 셀의 갯수를 설정
            return min(1, contentArray.count)
        } else if tableView == Star_with_Comment_TableView {
            return 1
        } else if tableView == MovieCast_TableView {
            return self.contentArray2.count
        }
        return 0
    }
    // 각 셀에 대한 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == CommentTableView {
            if reviewList.isEmpty {
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "리뷰가 없습니다."
                cell.textLabel?.textAlignment = .center // 문구를 가운데 정렬
                return cell
            } else {
                let cell = CommentTableView.dequeueReusableCell(withIdentifier: "myTableViewCell", for: indexPath) as! MyTableViewCell
                cell.userContentLabel.text = reviewList[indexPath.row].content
                cell.nickname.text =
                reviewList[indexPath.row].nickname
                cell.insertDate.text =
                reviewList[indexPath.row].insertdate
                return cell
            }
        } else if tableView == Movie_Information_TableView {
            let cell = Movie_Information_TableView.dequeueReusableCell(withIdentifier: "MovieInformationCell", for: indexPath) as! MovieInformationCell
            let content = contentArray[indexPath.row]
            cell.userContentLabel.text = content
            // 레이블의 줄 수를 설정합니다.
            if cell.isFullTextVisible {
                cell.userContentLabel.numberOfLines = 0 // 텍스트 줄 수 제한 없음
            } else {
                cell.userContentLabel.numberOfLines = 6 // 고정된 줄 수 (원하는 숫자로 변경)
            }
            return cell
        } else if tableView == Star_with_Comment_TableView {
            let cell = Star_with_Comment_TableView.dequeueReusableCell(withIdentifier: "Star_with_CommentCell", for: indexPath) as! Star_with_CommentCell

            return cell
        } else if tableView == MovieCast_TableView {
            let cell = MovieCast_TableView.dequeueReusableCell(withIdentifier: "MovieCastCell", for: indexPath) as! MovieCastCell
            let content = contentArray2[indexPath.row]
            cell.lblCastName.text = content
            return cell
        }
        return UITableViewCell()
    }
}


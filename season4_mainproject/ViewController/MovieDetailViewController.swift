//
//  MovieDetailViewController.swift
//  season4_mainproject
//
//  Created by 박지환 on 2023/09/25.
//

import UIKit

class MovieDetailViewController: UIViewController, MovieDetailDelegate {


    var reviewList: [Review] = []
    var Movie: [MovieDetailModel] = []
    var MovieCast: [MovieCastModel] = []
    let contentArray = ["아오 어려워아오 어려워아오 어려워아오 어려워아오 어려워아오 어려워아오"]
    let contentArray2 = ["아오 어려워", "뭐가 이리 많은거야", "확인하는 용도"]
    let reviewController = ReviewController(service: ReviewService())

    
    @IBOutlet weak var imgMoviePoster: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblMovieInformation: UILabel!
    @IBOutlet weak var Star_with_Comment_TableView: UITableView!
    @IBOutlet weak var Movie_Information_TableView: UITableView!
    @IBOutlet weak var MovieCast_TableView: UITableView!
    @IBOutlet weak var CommentTableView: UITableView!

    var receivedid: Int = 0

    func passMovieId(_ id: Int) {
        receivedid = id
    }

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
        let moviedetailQueryModel = MovieDetailQueryModel()
        moviedetailQueryModel.delegate = self
        moviedetailQueryModel.fetchDataFromAPI(seq: receivedid)
        
        let moviedetailcastQueryModel = MovieCastQueryModel()
        moviedetailcastQueryModel.delegate = self
        moviedetailcastQueryModel.fetchDataFromAPI(seq: receivedid)
        
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

    @IBAction func btnWrite(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Review", bundle: nil)
        guard let reviewVC = storyboard.instantiateViewController(identifier: "Review") as? ReviewViewController else { return }
        reviewVC.receivedId = receivedid
        // 모달로 화면 전환
        reviewVC.modalPresentationStyle = .formSheet

        // 모달 띄우기
        self.present(reviewVC , animated: true)
    }
    
    func urlImage() {
        // Movie 배열이 비어 있는지 확인
        guard !Movie.isEmpty else {
            print("Movie array is empty.")
            return
        }
        
        let imageUrlString = Movie[0].imagepath
        let imageUrl = URL(string: imageUrlString)

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
                        self?.imgMoviePoster.image = resizedImage
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

}
/*
// MARK: - EXTENSION
*/
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
                        cell.textLabel?.textAlignment = .center
                        return cell
                    } else {
                        let cell = CommentTableView.dequeueReusableCell(withIdentifier: "myTableViewCell", for: indexPath) as! MyTableViewCell
                        cell.userContentLabel.text = reviewList[indexPath.row].content
                        cell.nickname.text = reviewList[indexPath.row].nickname
                        cell.insertDate.text = reviewList[indexPath.row].insertdate
                        return cell
                    }
                } else if tableView == Movie_Information_TableView {
                    let cell = Movie_Information_TableView.dequeueReusableCell(withIdentifier: "MovieInformationCell", for: indexPath) as! MovieInformationCell
                    if !Movie.isEmpty {
                        let content = Movie[0].summary
                        cell.userContentLabel.text = content
                        cell.movie = Movie
                        if cell.isFullTextVisible {
                            cell.userContentLabel.numberOfLines = 0
                        } else {
                            cell.userContentLabel.numberOfLines = 6
                        }
                    }
                    return cell
                } else if tableView == Star_with_Comment_TableView {
                    let cell = Star_with_Comment_TableView.dequeueReusableCell(withIdentifier: "Star_with_CommentCell", for: indexPath) as! Star_with_CommentCell
                    if !Movie.isEmpty {
                        let starCount = Movie[0].star
                        let stars = [cell.star1, cell.star2, cell.star3, cell.star4, cell.star5]
                           for (index, starButton) in stars.enumerated() {
                               starButton?.tintColor = Int(starCount) > index ? UIColor.yellow : UIColor.gray
                           }
                    }
                        return cell
                } else if tableView == MovieCast_TableView {
                    let cell = MovieCast_TableView.dequeueReusableCell(withIdentifier: "MovieCastCell", for: indexPath) as! MovieCastCell
                    if !MovieCast.isEmpty {
                        cell.lblCastName.text = MovieCast[indexPath.row].name
                        cell.lblCastRole.text = MovieCast[indexPath.row].role
                        let imageUrlString = MovieCast[indexPath.row].imgpath
                        let imageUrl = URL(string: imageUrlString)
                        
                        URLSession.shared.dataTask(with: imageUrl!) { (data, response, error) in
                            if let error = error {
                                print("Error downloading image: \(error.localizedDescription)")
                                return
                            }
                            
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    // 이미지 크기 조정
                                    let imageSize = CGSize(width: 200, height: 250) // 원하는 크기로 조절
                                    UIGraphicsBeginImageContext(imageSize)
                                    image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
                                    if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
                                        cell.imgCast.image = resizedImage
                                    }
                                    UIGraphicsEndImageContext()
                                    //content.text = self.movieList[indexPath.row].title
                //                    content.secc = self.movieList[indexPath.row].genre
                                }
                            }
                        }.resume()
                        return cell
                    }
                }
                return UITableViewCell()
            }
        }

extension MovieDetailViewController: MovieDetailQueryModelProtocol{
    func itemDownloaded(item: [MovieDetailModel]) {
        Movie = item
        urlImage()
        lblMovieTitle.text = Movie[0].title
        lblMovieInformation.text = String(Movie[0].releasedate.prefix(4)) + " · " + Movie[0].country + " · " + Movie[0].genre
        
        DispatchQueue.main.async { [weak self] in
            self?.Star_with_Comment_TableView.reloadData()
                    self?.Movie_Information_TableView.reloadData()
                }
    }
}
extension MovieDetailViewController: MovieCastProtocol{
    func itemDownloaded(item: [MovieCastModel]) {
        MovieCast = item
        DispatchQueue.main.async { [weak self] in
            self?.MovieCast_TableView.reloadData()
                }
    }


}

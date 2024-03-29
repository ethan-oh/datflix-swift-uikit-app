//
//  MovieDetailViewController.swift
//  season4_mainproject
//
//  Created by 박지환 on 2023/09/25.
//

import UIKit

class MovieDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {


    var reviewList: [Review] = []
    var Movie: [MovieDetailModel] = []
    var MovieCast: [MovieCastModel] = []
    let reviewController = ReviewController(service: ReviewService())
    var recommendMovie: [MovieModel] = []

    @IBOutlet weak var imgMoviePoster: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblMovieInformation: UILabel!
    @IBOutlet weak var Star_with_Comment_TableView: UITableView!
    @IBOutlet weak var Movie_Information_TableView: UITableView!
    @IBOutlet weak var MovieCast_TableView: UITableView!
    @IBOutlet weak var CommentTableView: UITableView!


    @IBOutlet weak var cvCastView: UICollectionView!
    @IBOutlet weak var cvRecommendView: UICollectionView!


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



        // 아주 중요
        self.cvRecommendView.delegate = self
        self.cvRecommendView.dataSource = self
        self.cvCastView.delegate = self
        self.cvCastView.dataSource = self


        let CommentViewCellNib = UINib(nibName: String(describing: MyTableViewCell.self), bundle: nil)

        // 셀에 리소스 등록
        self.CommentTableView.register(CommentViewCellNib, forCellReuseIdentifier: "myTableViewCell")

        self.CommentTableView.rowHeight = UITableView.automaticDimension
        self.CommentTableView.estimatedRowHeight = 120

        // 아주 중요
        self.CommentTableView.delegate = self
        self.CommentTableView.dataSource = self


        // Do any additional setup after loading the view.

    }


    override func viewWillAppear(_ animated: Bool) {
        // 네비게이션바, 탭바 스크롤 시에도 색상 유지하는 기능
        setDelegateAndDataSource(cvCastView)
        setDelegateAndDataSource(cvRecommendView)
        // 컬렉션뷰 수평 스크롤 세팅
        horizontalSetting(cvCastView)
        horizontalSetting(cvRecommendView)
        // 컬렉션뷰 배경 투명하게
        clearBackGround(cvCastView)
        clearBackGround(cvRecommendView)
        readValues()
    }

    func readValues() {
        let moviedetailQueryModel = MovieDetailQueryModel()
        moviedetailQueryModel.delegate = self
        moviedetailQueryModel.fetchDataFromAPI(seq: receivedid)

        let moviedetailcastQueryModel = MovieCastQueryModel()
        moviedetailcastQueryModel.delegate = self
        moviedetailcastQueryModel.fetchDataFromAPI(seq: receivedid)
        
        let cast = MovieCastQueryModel()
        cast.delegate = self
        cast.fetchDataFromAPI(seq: receivedid)
        
        
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
        if UserDefaults.standard.string(forKey: "access_token") == nil {
            // access_token이 없으면 로그인을 물어보는 Alert 표시
            let alert = UIAlertController(title: "로그인이 필요합니다", message: "로그인하시겠습니까?", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "예", style: .default) { _ in
                if let tabBarController = self.tabBarController {
                    tabBarController.selectedIndex = 2 // 로그인 탭
                }
            }
            let CancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)

            alert.addAction(OKAction)
            alert.addAction(CancelAction)

            present(alert, animated: true, completion: nil)
        } else {
            reviewController.hasWritten(movie_id: receivedid) { hasWritten in
                if hasWritten {
                    let alert = UIAlertController(title: "이미 작성된 리뷰가 있습니다.", message: "리뷰를 수정하시겠습니까?", preferredStyle: .alert)

                    // 예 버튼 누를 경우
                    let yesAction = UIAlertAction(title: "예", style: .default) { _ in
                        showReviewViewController(true)
                    }
                    let CancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
                    alert.addAction(yesAction)
                    alert.addAction(CancelAction)
                    self.present(alert, animated: true)
                } else {
                    // 사용자가 리뷰를 작성하지 않은 경우
                    let alert = UIAlertController(title: "리뷰 작성", message: "리뷰를 작성하시겠습니까?", preferredStyle: .alert)

                    // 예 버튼 누를 경우
                    let yesAction = UIAlertAction(title: "예", style: .default) { _ in
                        showReviewViewController(false)
                    }
                    let CancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
                    alert.addAction(yesAction)
                    alert.addAction(CancelAction)
                    self.present(alert, animated: true)
                }
            }
        }

        func showReviewViewController(_ editmode : Bool) {
            let storyboard = UIStoryboard(name: "Review", bundle: nil)
            guard let reviewVC = storyboard.instantiateViewController(identifier: "Review") as? ReviewViewController else { return }
            reviewVC.editmode = editmode
            reviewVC.receivedId = self.receivedid
            reviewVC.receivedTitle = self.Movie[0].title
            reviewVC.receivedGenre = self.Movie[0].genre
            reviewVC.receivedCountry = self.Movie[0].country
            reviewVC.imagePath = self.Movie[0].imagepath
            reviewVC.receivedRelease = self.Movie[0].releasedate
            // 모달로 화면 전환
            reviewVC.modalPresentationStyle = .formSheet

            // 모달 띄우기
            self.present(reviewVC, animated: true)
        }
    }
    
    

    func urlImage() {
        // Movie 배열이 비어 있는지 확인
        guard !Movie.isEmpty else {
            print("Movie array is empty.")
            return
        }
        
        let imageUrlString = Movie[0].imagepath
        let trimmedImageUrlString = imageUrlString.trimmingCharacters(in: .whitespacesAndNewlines)
        let imageUrl = URL(string: trimmedImageUrlString)

        // 이미지 다운로드는 백그라운드 스레드에서 수행
        DispatchQueue.global().async {
            if let imageUrl = imageUrl, let imageData = try? Data(contentsOf: imageUrl), let image = UIImage(data: imageData) {
                // 이미지 크기 조정
                let imageSize = CGSize(width: 110, height: 150) // 원하는 크기로 조절
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

    func setDelegateAndDataSource(_ view: UICollectionView) {
        view.delegate = self
        view.dataSource = self
    }


    func horizontalSetting(_ view: UICollectionView) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        view.collectionViewLayout = layout
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

    // 셀 개수 리턴
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvRecommendView {
            return recommendMovie.count
        }else if collectionView == cvCastView {
            if !MovieCast.isEmpty{
                return MovieCast.count
            }
        }
        return 0
    }

    // 셀별 세팅
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
            switch collectionView {
            case cvCastView:
                let imageUrlString = MovieCast[indexPath.row].imgpath.trimmingCharacters(in: .whitespacesAndNewlines)
                cell = cvCastView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as! CastCollectionViewCell
                    configureCell(cell as! CastCollectionViewCell, withImageURL: imageUrlString)
                let castCell = cell as! CastCollectionViewCell
                castCell.CastName.text = MovieCast[indexPath.row].name
                castCell.CastRole.text = MovieCast[indexPath.row].role
            case cvRecommendView:
                cell = cvRecommendView.dequeueReusableCell(withReuseIdentifier: "recommendCell", for: indexPath) as! RecommendCollectionViewCell
                if !recommendMovie.isEmpty{
                    configureCell(cell as! RecommendCollectionViewCell, withImageURL: recommendMovie[indexPath.row].imagepath)
                }
            default:
                cell = UICollectionViewCell()
            }

        return cell
    }
    
    // segment별 셀 클릭 시 데이터 넘겨주기(id값)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sgDetail" {
            let cell = sender as! RecommendCollectionViewCell
            let indexPath = self.cvRecommendView.indexPath(for: cell)
            let detailView = segue.destination as! MovieDetailViewController
            detailView.receivedid = recommendMovie[indexPath!.row].id
        }
    }
    

    // 셀 이미지 담아주기. 바로 위 셀별 세팅에서 호출해서 사용한다.
    func configureCell(_ cell: UICollectionViewCell, withImageURL imageUrlString: String) {
        let trimmedImageUrlString = imageUrlString.trimmingCharacters(in: .whitespacesAndNewlines)
        let imageUrl = URL(string: trimmedImageUrlString)
        URLSession.shared.dataTask(with: imageUrl!) { (data, response, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }

            if let data = data, let image = UIImage(data: data) {
                // 비동기방식으로 이미지 불러와 담아주기
                DispatchQueue.main.async {
                    if let movieCell = cell as? RecommendCollectionViewCell {
                        movieCell.movieImage.image = image
                    }else if let castCell = cell as? CastCollectionViewCell {
                        castCell.movieImage.image = image
                        print(image)
                    }
                }
            }
        }.resume()
    }

    func clearBackGround(_ view: UICollectionView) {
        view.backgroundColor = UIColor.clear
        view.backgroundView = nil
    }



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
            return min(1, Movie.count)
        } else if tableView == Star_with_Comment_TableView {
            return 1
        } else if tableView == MovieCast_TableView {
            return self.MovieCast.count
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
                cell.textLabel?.textColor = UIColor.white
                if let background = UIColor(named: "background") {
                    cell.backgroundColor = background
                    tableView.backgroundColor = background
                }
                return cell
            } else {
                let cell = CommentTableView.dequeueReusableCell(withIdentifier: "myTableViewCell", for: indexPath) as! MyTableViewCell
                cell.userContentLabel.text = reviewList[indexPath.row].content
                cell.nickname.text = reviewList[indexPath.row].nickname
                cell.insertDate.text = reviewList[indexPath.row].insertdate
                cell.cosmosOh.rating = reviewList[indexPath.row].rating
                return cell
            }
        } else if tableView == Movie_Information_TableView {
            let cell = Movie_Information_TableView.dequeueReusableCell(withIdentifier: "MovieInformationCell", for: indexPath) as! MovieInformationCell
            if !Movie.isEmpty {
                var content = Movie[0].summary
                
                // content 문자열의 마지막 글자가 "0"이면 제거
                if content.last == "0" {
                    content = String(content.dropLast())
                }
                
                // content 문자열이 모두 "0"으로 이루어진 경우 처리
                if content.allSatisfy({ $0 == "0" }) {
                    content = ""
                }
                
                if content.isEmpty {
                    cell.textLabel?.text = "기본정보가 없습니다."
                    cell.textLabel?.textAlignment = .center
                    cell.textLabel?.textColor = UIColor.white
                    cell.moreButton.isHidden = true
                    if let background = UIColor(named: "background") {
                        cell.backgroundColor = background
                        tableView.backgroundColor = background
                    }
                } else {
                    cell.userContentLabel.text = content
                    cell.movie = Movie
                    if let background = UIColor(named: "background") {
                        cell.backgroundColor = background
                        tableView.backgroundColor = background
                    }
                    if cell.isFullTextVisible {
                        cell.userContentLabel.numberOfLines = 0
                    } else {
                        cell.userContentLabel.numberOfLines = 9
                    }
                }
            }
            return cell
        } else if tableView == Star_with_Comment_TableView {
            let cell = Star_with_Comment_TableView.dequeueReusableCell(withIdentifier: "Star_with_CommentCell", for: indexPath) as! Star_with_CommentCell
            if !Movie.isEmpty {
                let starCount = Movie[0].star
                if starCount <= 0.0 {
                        cell.star1.tintColor = UIColor.gray
                        cell.star2.tintColor = UIColor.gray
                        cell.star3.tintColor = UIColor.gray
                        cell.star4.tintColor = UIColor.gray
                        cell.star5.tintColor = UIColor.gray
                    } else if starCount < 2.0 {
                        cell.star1.tintColor = UIColor.yellow
                        cell.star2.tintColor = UIColor.gray
                        cell.star3.tintColor = UIColor.gray
                        cell.star4.tintColor = UIColor.gray
                        cell.star5.tintColor = UIColor.gray
                    } else if starCount < 4.0 {
                        cell.star1.tintColor = UIColor.yellow
                        cell.star2.tintColor = UIColor.yellow
                        cell.star3.tintColor = UIColor.gray
                        cell.star4.tintColor = UIColor.gray
                        cell.star5.tintColor = UIColor.gray
                    } else if starCount < 6.0 {
                        cell.star1.tintColor = UIColor.yellow
                        cell.star2.tintColor = UIColor.yellow
                        cell.star3.tintColor = UIColor.yellow
                        cell.star4.tintColor = UIColor.gray
                        cell.star5.tintColor = UIColor.gray
                    } else if starCount < 8.0 {
                        cell.star1.tintColor = UIColor.yellow
                        cell.star2.tintColor = UIColor.yellow
                        cell.star3.tintColor = UIColor.yellow
                        cell.star4.tintColor = UIColor.yellow
                        cell.star5.tintColor = UIColor.gray
                    } else {
                        cell.star1.tintColor = UIColor.yellow
                        cell.star2.tintColor = UIColor.yellow
                        cell.star3.tintColor = UIColor.yellow
                        cell.star4.tintColor = UIColor.yellow
                        cell.star5.tintColor = UIColor.yellow
                    }
                }
            return cell
        }
        return UITableViewCell()
    }
}

extension MovieDetailViewController: MovieDetailQueryModelProtocol {
    func itemDownloaded(item: [MovieDetailModel]) {
        Movie = item
        urlImage()
        lblMovieTitle.text = Movie[0].title
        lblMovieInformation.text = String(Movie[0].releasedate.prefix(4)) + " · " + Movie[0].country + " · " + Movie[0].genre
        let aiService = AiService()
        aiService.delegate = self
        aiService.searchTop(title: Movie[0].title)
        
        DispatchQueue.main.async { [weak self] in
            self?.CommentTableView.reloadData()
            self?.Star_with_Comment_TableView.reloadData()
            self?.Movie_Information_TableView.reloadData()
        }
    }
}
extension MovieDetailViewController: MovieCastProtocol {
    func itemDownloaded(item: [MovieCastModel]) {
        MovieCast = item
        DispatchQueue.main.async { [weak self] in
            self?.cvRecommendView.reloadData()
            self?.cvCastView.reloadData()
        }
    }


}

extension MovieDetailViewController: JSONMovieQueryModelProtocol{
    func itemDownloaded(item: [MovieModel]) {
        recommendMovie = item
        DispatchQueue.main.async { [weak self] in
            self?.cvRecommendView.reloadData()
        }
    }
    
    
}
// 컬렉션뷰 사이즈와 간격 세팅
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout{
    // 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // 1픽셀
    }
    
    // 좌우 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // Cell Size ( 옆 라인을 고려하여 설정)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cvRecommendView {
            return CGSize(width: 154+10, height: 185)
        }else {
            return CGSize(width: 127+10, height: 185) // 마진 10 주기
        }
        
    }
    
}

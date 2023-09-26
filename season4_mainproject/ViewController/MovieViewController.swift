//
//  MovieViewController.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/26.
//
import UIKit

class MovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var cvListView: UICollectionView! // IBOutlet으로 컬렉션 뷰 연결
    
    var movieList: [MovieModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UICollectionView 설정
        cvListView.delegate = self
        cvListView.dataSource = self
        
        // UICollectionViewFlowLayout을 사용하여 수평 스크롤 설정
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        cvListView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cvListView.backgroundColor = UIColor.clear
        cvListView.backgroundView = nil
        readValues()
    }
    
    func readValues() {
        let movieQueryModel = JSONAMovieQueryModel()
        movieQueryModel.delegate = self
        movieQueryModel.fetchDataFromAPI()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvListView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MovieCollectionViewCell
        
        let imageUrlString = movieList[indexPath.row].imagepath
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
                        cell.movieImage.image = resizedImage
                    }
                    UIGraphicsEndImageContext()
                    //content.text = self.movieList[indexPath.row].title
//                    content.secc = self.movieList[indexPath.row].genre
                }
            }
        }.resume()
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "sgDetail" {
                let cell = sender as! MovieCollectionViewCell
                let indexPath = self.cvListView.indexPath(for: cell)
                let detailView = segue.destination as! MovieDetailViewController
                detailView.receivedid = movieList[indexPath!.row].id
                print("아이디")
                print(movieList[indexPath!.row].id)
                // Get the new view controller using segue.destination.
                // Pass the selected object to the new view controller.
            }
        }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 셀 선택 시 처리 (예: 상세 화면으로 이동)
    }
}

extension MovieViewController: JSONMovieQueryModelProtocol {
    func itemDownloaded(item: [MovieModel]) {
        movieList = item
        self.cvListView.reloadData()
    }
}

extension MovieViewController: UICollectionViewDelegateFlowLayout{
    // 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // 1픽셀
    }
    
    // 좌우 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Cell Size ( 옆 라인을 고려하여 설정)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 1
        let size = CGSize(width: width, height: width)
        
        return size
    }
}

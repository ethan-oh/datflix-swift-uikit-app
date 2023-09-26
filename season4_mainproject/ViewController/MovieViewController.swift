//
//  MovieViewController.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/26.
//
import UIKit

class MovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    
    @IBOutlet weak var cvDramaView: UICollectionView!
    @IBOutlet weak var cvOTTView: UICollectionView!
    @IBOutlet weak var cvListView: UICollectionView! // IBOutlet으로 컬렉션 뷰 연결
    
    var movieList: [MovieModel] = []
    var ottList: [MovieModel] = []
    var dramaList: [MovieModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UICollectionView 설정
        cvListView.delegate = self
        cvListView.dataSource = self
        cvOTTView.delegate = self
        cvOTTView.dataSource = self
        cvDramaView.delegate = self
        cvDramaView.dataSource = self
        
        // UICollectionViewFlowLayout을 사용하여 수평 스크롤 설정
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        cvListView.collectionViewLayout = layout
        cvOTTView.collectionViewLayout = layout
        cvDramaView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 컬렉션뷰 배경 투명하게
        cvListView.backgroundColor = UIColor.clear
        cvListView.backgroundView = nil
        cvOTTView.backgroundColor = UIColor.clear
        cvOTTView.backgroundView = nil
        cvDramaView.backgroundColor = UIColor.clear
        cvDramaView.backgroundView = nil
        readValues()
    }
    
    func readValues() {
        let movieQueryModel = JSONAMovieQueryModel()
        movieQueryModel.delegate = self
        movieQueryModel.fetchDataFromAPI()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvListView {
            return movieList.count
        }else if collectionView == cvOTTView {
            return ottList.count
        }else if collectionView == cvDramaView {
            return dramaList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cvListView {
            let cell = cvListView.dequeueReusableCell(withReuseIdentifier: "rankCell", for: indexPath) as! MovieCollectionViewCell
            let imageUrlString = movieList[indexPath.row].imagepath
            let imageUrl = URL(string: imageUrlString)
            
            URLSession.shared.dataTask(with: imageUrl!) { (data, response, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.movieImage.image = image
                    }
                }
            }.resume()
            
            return cell
        } else if collectionView == cvOTTView {
            let cell = cvOTTView.dequeueReusableCell(withReuseIdentifier: "ottCell", for: indexPath) as! OTTCollectionViewCell
            let imageUrlString = ottList[indexPath.row].imagepath // ottList를 사용하도록 수정
            let imageUrl = URL(string: imageUrlString)
            
            URLSession.shared.dataTask(with: imageUrl!) { (data, response, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.movieImage.image = image
                    }
                }
            }.resume()
            
            return cell
        }else if collectionView == cvDramaView {
            let cell = cvDramaView.dequeueReusableCell(withReuseIdentifier: "dramaCell", for: indexPath) as! DramaCollectionViewCell
            let imageUrlString = dramaList[indexPath.row].imagepath // ottList를 사용하도록 수정
            let imageUrl = URL(string: imageUrlString)
            
            URLSession.shared.dataTask(with: imageUrl!) { (data, response, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.movieImage.image = image
                    }
                }
            }.resume()
            
            return cell
        }
        
        return UICollectionViewCell()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "sgDetail" {
                let cell = sender as! MovieCollectionViewCell
                let indexPath = self.cvListView.indexPath(for: cell)
                let detailView = segue.destination as! MovieDetailViewController
                detailView.receivedid = movieList[indexPath!.row].id
            }else if segue.identifier == "sgOTTDetail" {
                let cell = sender as! OTTCollectionViewCell
                let indexPath = self.cvOTTView.indexPath(for: cell)
                let detailView = segue.destination as! MovieDetailViewController
                detailView.receivedid = ottList[indexPath!.row].id
            }else if segue.identifier == "sgDramaDetail" {
                let cell = sender as! OTTCollectionViewCell
                let indexPath = self.cvDramaView.indexPath(for: cell)
                let detailView = segue.destination as! MovieDetailViewController
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
        for movie in movieList{
            if movie.ott != "영화"{
                ottList.append(movie)
            }
            if movie.genre.contains("드라마"){
                dramaList.append(movie)
            }
        }
        self.cvListView.reloadData()
        self.cvOTTView.reloadData()
        self.cvDramaView.reloadData()
    }
}

extension MovieViewController: UICollectionViewDelegateFlowLayout{
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
        return CGSize(width: 127+10, height: 185)
    }
    
}


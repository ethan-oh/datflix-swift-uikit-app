//
//  MovieTableViewController.swift
//  ScrollView
//
//  Created by 박지환 on 2023/09/22.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    
    @IBOutlet var tvListView: UITableView!
    
    var AddressList: [MovieModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
            readValues()
        }
        
        func readValues(){
            let movieQueryModel = JSONAMovieQueryModel()
            movieQueryModel.delegate = self
            movieQueryModel.fetchDataFromAPI() // 데이터 가져와서 화면에 구성된다.
        }

    
    
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AddressList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let imageUrlString = AddressList[indexPath.row].imagepath
        let imageUrl = URL(string: imageUrlString)

        // 이미지 다운로드 비동기 처리
        URLSession.shared.dataTask(with: imageUrl!) { (data, response, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }

            // 데이터가 정상적으로 가져와졌다면 UIImage로 변환하여 설정
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    // 이미지 크기 조정
                    let imageSize = CGSize(width: 100, height: 100) // 원하는 크기로 조절
                    UIGraphicsBeginImageContext(imageSize)
                    image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
                    if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
                        content.image = resizedImage
                    }
                    UIGraphicsEndImageContext()
                    content.text = self.AddressList[indexPath.row].title
                    content.secondaryText = self.AddressList[indexPath.row].genre
                    cell.contentConfiguration = content
                    // 이제 이미지 크기 조정 코드가 정상적으로 동작합니다.
                }
            }
        }.resume()
        
        return cell
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "sgDetail" {
                let cell = sender as! UITableViewCell
                let indexPath = self.tvListView.indexPath(for: cell)
                let detailView = segue.destination as! MovieDetailViewController
                detailView.receivedid = AddressList[indexPath!.row].id
                // Get the new view controller using segue.destination.
                // Pass the selected object to the new view controller.
            }
        }


} //MovieTableViewController

extension MovieTableViewController: JSONMovieQueryModelProtocol{
    func itemDownloaded(item: [MovieModel]) {
        AddressList = item
        self.tvListView.reloadData()
    }
}


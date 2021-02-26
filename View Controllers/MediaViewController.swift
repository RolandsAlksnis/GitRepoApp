//
//  MediaViewController.swift
//

import UIKit
import AVKit
import AVFoundation

struct MediaContent: Decodable {
    let name: String?
    let download_url: String?
}

class MediaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var gitDataGlobal = [MediaContent]()
    var selectedMedia: MediaContent?
    
    
    @IBOutlet weak var mediaTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            mediaTable.delegate = self
            mediaTable.dataSource = self

            downloadJson(for: UserDefaults.standard.string(forKey: "Username")!)
    }
    
    func mediaArraySorter(with allData: [MediaContent]) -> [MediaContent] {
        var multiplayerData: [MediaContent] = []
        for data in allData {
            if let fileName = data.name {
                let fileNameArr = fileName.components(separatedBy: ".")
                if fileNameArr.last == "mp4" {
                    multiplayerData.append(data)
                }
            }
        }
        return multiplayerData
    }

    
    func downloadJson(for userName: String) {
        guard let url = URL(string: "https://api.github.com/repos/" + userName + "/MyFilesContent/contents/") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let gitDataLocal = try JSONDecoder().decode([MediaContent].self, from: data)
                self.gitDataGlobal = self.mediaArraySorter(with: gitDataLocal)
                for document in self.gitDataGlobal {
                    self.downloadFile(with: URL(string: document.download_url!)!, with: document.name!)
                }
            } catch let err {
                print("Err", err)
            }
            }.resume()
    }
    
    
    func downloadFile(with url: URL, with fileName: String) {
        URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) in
            if let errorExists = error {
                print(errorExists)
                return
            }
            if let locationExists = location {
                self.saveFile(from: locationExists, with: fileName)
            } else {
                print("Error: invalid temporary location")
            }
        }).resume()
    }
    
    
    func saveFile(from temporaryLocationUrl: URL, with fileName: String){
        let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filePathInLocalStorage = documentsUrl.appendingPathComponent(fileName)
        if FileManager().fileExists(atPath: filePathInLocalStorage.path) {
            print("The file already exists at path, deleting and replacing with latest")
            
            if FileManager().isDeletableFile(atPath: filePathInLocalStorage.path){
                do{
                    try FileManager().removeItem(at: filePathInLocalStorage)
                    print("previous file deleted")
                } catch {
                    print("current file could not be deleted")
                }
            }
        }
        do {
            try FileManager.default.moveItem(at: temporaryLocationUrl, to: filePathInLocalStorage)
            print("new file saved")
        } catch {
            print("file could not be saved: \(error)")
        }
        DispatchQueue.main.async {
            self.mediaTable.reloadData()
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AVPlayerViewIdentifier" {
            let avPlayerVC = segue.destination as! PlayerViewController
            avPlayerVC.currentMedia = self.selectedMedia
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(gitDataGlobal.count)
        return gitDataGlobal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = mediaTable.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        let docData = gitDataGlobal[indexPath.row]
        cell.cellLabelTwo.text = docData.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedMedia = gitDataGlobal[indexPath.row]
        performSegue(withIdentifier: "AVPlayerViewIdentifier", sender: nil)
        
    }

}

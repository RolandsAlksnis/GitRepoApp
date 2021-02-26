//
//  DocumentsViewController.swift
//

import UIKit
import Foundation

struct DocumentsContent: Decodable {
    let name: String?
    let download_url: String?
}

class DocumentsViewController: UIViewController {
    
    @IBOutlet weak var documentsTable: UITableView!
    
    var gitDataGlobal = [DocumentsContent]()
    var selectedDocument: DocumentsContent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            documentsTable.delegate = self
            documentsTable.dataSource = self
        
            downloadJson(for: UserDefaults.standard.string(forKey: "Username")!)
    }
    
    
    
    func pdfArray(with allData: [DocumentsContent]) -> [DocumentsContent] {
        var pdfData: [DocumentsContent] = []
        for data in allData {
            if let fileName = data.name {
                let fileNameArr = fileName.components(separatedBy: ".")
                if fileNameArr.last == "pdf" {
                    pdfData.append(data)
                }
            }
        }
        return pdfData
    }
    
    



    
    // pass value Data with segue: for example the REPO Name from previous viewcontroller
    

    func downloadJson(for userName: String) {
        let nManager = NetworkManager(userName: userName, repoName: "MyFilesContent")
        if let validUrl = nManager.completeUserRepoUrlForContents() {
            print(validUrl)
        URLSession.shared.dataTask(with: validUrl) { (data, response, error) in
            guard let data = data else { return }
            do {
                let gitDataLocal = try JSONDecoder().decode([DocumentsContent].self, from: data)
                self.gitDataGlobal = self.pdfArray(with: gitDataLocal)
                for document in self.gitDataGlobal {
                    self.downloadFile(with: URL(string: document.download_url!)!, with: document.name!)
                }
            } catch let err {
                print("Err", err)
            }
            }.resume()
        }
    }

    
    

    
    func downloadFile(with url: URL, with fileName: String) {
        URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) in
            // after downloading your data you need to save it to your destination url
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
    }      //             <------- FUNCTION ENDS
    
    
    


    
    func saveFile(from temporaryLocationUrl: URL, with fileName: String){
        // after downloading your data you need to save it to your destination url
        let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let filePathInLocalStorage = documentsUrl.appendingPathComponent(fileName)
        
        if FileManager().fileExists(atPath: filePathInLocalStorage.path) {
            print("The file already exists at path, deleting and replacing with latest")
            
            if FileManager().isDeletableFile(atPath: filePathInLocalStorage.path){
                do{
                    try FileManager().removeItem(at: filePathInLocalStorage)
                    print("previous file deleted")
                }catch{
                    print("current file could not be deleted")
                }
            }
            // download the data from your url
        }
            do {
                try FileManager.default.moveItem(at: temporaryLocationUrl, to: filePathInLocalStorage)
                print("new file saved")
            } catch {
                print("file could not be saved: \(error)")
            }
   //     loadFileAsync(from: filePathInLocalStorage)
        DispatchQueue.main.async {
            self.documentsTable.reloadData()
        }
    }              //     <-------- ENDS FUNCTION
    
    
    
//    func loadFileAsync(from filePathInLocalStorage: URL) {
//        let localData = try! Data(contentsOf: filePathInLocalStorage)
//        do {
//            let gitDataLocal = try JSONDecoder().decode([DocumentsContent].self, from: localData)
//            print(gitDataLocal)
//            print(gitDataLocal.count)
//            self.gitDataGlobal = self.pdfArray(with: gitDataLocal)
//            DispatchQueue.main.async {
//                self.documentsTable.reloadData()
//            }
//        } catch let err {
//            print("Err", err)
//        }
//
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webViewIdentifier" {
            let webKitVC = segue.destination as! WebKitViewController
            webKitVC.currentDocument = self.selectedDocument
        }
    }
    
    // norada, uz kurieni tiek nosutiti dati ar segue palidzibu
    
}           // Class DocumentsViewController Ends <-----------------------


extension DocumentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         print(gitDataGlobal)
         return gitDataGlobal.count                               // return userDoc.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = documentsTable.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        let docData = gitDataGlobal[indexPath.row]
        cell.cellLabel.text = docData.name
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedDocument = gitDataGlobal[indexPath.row]
        performSegue(withIdentifier: "webViewIdentifier", sender: nil)
        
    }
    
}           // Extension ends <------------------------
    
    
    




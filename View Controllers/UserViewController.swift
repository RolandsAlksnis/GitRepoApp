//
//  UserViewController.swift
//

import UIKit

struct GitHubContent {
    let name: String?
    let company: String?
    let bio: String?
    let imageURL: String?
}

class UserViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func logoutButton(_ sender: Any) {
        loadLoginScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if isUserLoggedIn() {
            fetchUserData(for: UserDefaults.standard.string(forKey: "Username")!)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func loadLoginScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
    func isUserLoggedIn() -> Bool {
        if let validUsername =  UserDefaults.standard.string(forKey: "Username") {
            if validUsername.count != 0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

    
    func fetchUserData(for userName: String) -> Void {
        
        let url = URL(string: "https://api.github.com/users/" + userName)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                do {
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    if let validDictionary = jsonSerialized {
                        
                        
                        let validName = validDictionary["name"] as? String
                        let validCompnay = validDictionary["company"] as? String
                        let validBio = validDictionary["bio"] as? String
                        let validImageUrl = validDictionary["avatar_url"] as? String
                        
                        DispatchQueue.main.async{
                            self.nameLabel.text = validName ?? "No name received"
                            self.companyLabel.text = validCompnay ?? "No company received"
                            self.bioLabel.text = validBio ?? "No bio received"
                            self.profileImage.downloaded(from: validImageUrl ?? "https://dummyimage.com/500x500/000/fff&text=Att%C4%93ls+nav+atrasts")
                        }
                        
                    } else {
                        print("Error: Dati nav derīgi")
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

    
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

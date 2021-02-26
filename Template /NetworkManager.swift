//
//  NetworkManager.swift
//

import Foundation

enum NetworkConstants: String {
    case githubRootUrl = "https://api.github.com/repos"
}

struct NetworkManager {

    let userName: String
    let repoName: String

    func completeUserRepoUrlForContents() -> URL? {
        return URL(string: "\(NetworkConstants.githubRootUrl.rawValue)/\(self.userName)/\(self.repoName)/contents/")
    }
}




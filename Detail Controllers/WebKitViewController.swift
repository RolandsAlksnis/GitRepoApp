//
//  WebKitView.swift
//  Lumen
//
//  Created by rolands.alksnis on 15/07/2019.
//  Copyright © 2019 rolands.alksnis. All rights reserved.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var currentDocument: DocumentsContent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let validFileName = currentDocument?.name {
            let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let filePathInLocalStorage = documentsUrl.appendingPathComponent(validFileName)
            webView.loadFileURL(filePathInLocalStorage, allowingReadAccessTo: filePathInLocalStorage.deletingLastPathComponent())
        } else {
            print("ERROR: File oppening terminated - no filename")
        }
    }
    
    
    
}







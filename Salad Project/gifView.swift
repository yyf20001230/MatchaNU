//
//  gifView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 9/24/21.
//

import SwiftUI
import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    var imageNames = ["1","2"]
    var images = [UIImage]()
    override func viewDidLoad() {
        //super.viewDidLoad()
        for image in imageNames{
            images.append(UIImage(named: image)!)
        }
        
        imageView.animationImages = images
        imageView.animationDuration = 1.0
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
    }
}


/*
struct gifView: UIViewRepresentable{
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let url = Bundle.main.url(forResource: "Matcha", withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webView.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
        if webView.isFocused{
            webView.isHidden = true
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}
 
*/

//
//  UiView-Helper.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/27/23.
//

import Foundation

import UIKit

extension UIImageView {

    func getImage (stringUrl: String) {
        /* It's important to note that the Data(contentsOf:) method will download the contents of the url synchronously in the same thread the code is being executed, so do not invoke this in the main thread of your application */
        let url = URL(string: stringUrl)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
    }
    
    func circleImage () {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowRadius = self.frame.height/2
        self.layer.shadowOpacity = 0.5
        //        self.layer.masksToBounds = true
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
    
    //Helper to make cornerRadius with black shadow to image..(imageView should be inside ContinerView)
    func applyShadowWithCornerRadius(containerView: UIView, cornerRadius: CGFloat) {
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadius).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
    
    
    func downloadImage(urlString: String) {
        downloadImage(url: URL(string: urlString)!)
    }
    
    func downloadImage(url: URL) {
//        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
    
}
     
     
    
    
    

    


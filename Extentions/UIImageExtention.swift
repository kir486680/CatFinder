//
//  UIImageExtention.swift
//  compProj
//
//  Created by Kirill Kalashnikov on 5/22/20.
//  Copyright © 2020 Kirill Kalashnikov. All rights reserved.
//

import Foundation
import UIKit

// This is another possibility to load data from URL.
//Not implemented by me - FOUND ON STACKOVERFLOW

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {

           if self.image == nil{
                 self.image = PlaceHolderImage
           }

           URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

               if error != nil {
                   print(error ?? "No Error")
                   return
               }
               DispatchQueue.main.async(execute: { () -> Void in
                   let image = UIImage(data: data!)
                   self.image = image
               })

           }).resume()
    }
}

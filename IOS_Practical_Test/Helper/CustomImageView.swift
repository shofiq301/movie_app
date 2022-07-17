//
//  CustomImageView.swift
//  IOS_Practical_Test
//
//  Created by IOTA INFOTECH LIMITED on 17/7/22.
//

import Foundation
import UIKit
import Kingfisher
let imageCache = NSCache<NSString, UIImage>()
class CustomImageView: UIImageView {
    func loadImageUsingUrlString(urlString: String) {
        let photoUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.image = nil
        self.kf.indicatorType = .activity
        DispatchQueue.main.async {
            DownloadImageHelper.sharedInstance.downloadImage(with: photoUrl){image in
                guard let image  = image else { return}
                self.image = image.resizeImageWithHeight(newW: 80.0, newH: 100.0)
                imageCache.setObject(image, forKey: urlString as NSString)
             }
        }
    }
    
}

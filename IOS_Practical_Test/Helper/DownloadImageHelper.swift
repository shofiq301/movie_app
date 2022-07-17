//
//  DownloadImageHelper.swift
//  IOS_Practical_Test
//
//  Created by IOTA INFOTECH LIMITED on 17/7/22.
//

import Foundation
import Kingfisher
import UIKit
class DownloadImageHelper: NSObject {
    static let sharedInstance = DownloadImageHelper()
    func downloadImage(with urlString : String , imageCompletionHandler: @escaping (UIImage?) -> Void){
        guard let url = URL.init(string: Helper.shared.imageBase + urlString) else {
                return  imageCompletionHandler(nil)
            }
            let resource = ImageResource(downloadURL: url)
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    imageCompletionHandler(value.image)
                case .failure:
                    imageCompletionHandler(nil)
                }
            }
        }
}

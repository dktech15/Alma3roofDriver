//
//  myImageDownloader.swift
//  tableViewDemo
//
//  Created by Elluminati on 17/01/17.
//  Copyright © 2017 tag. All rights reserved.

import UIKit
import ImageIO
import SDWebImage
extension UIImageView
{
    
    func downloadedFrom(link: String,
                        placeHolder:String = "asset-profile-placeholder",
                        isFromCache:Bool = true,
                        isIndicator:Bool = false,
                        mode:UIView.ContentMode = .scaleAspectFill,
                        isAppendBaseUrl:Bool = true) {

        self.contentMode = mode

        let placeHolderImage = UIImage(named: placeHolder)
        self.image = placeHolderImage

        if link.isEmpty {
            return
        }
        else {
            let strlink = isAppendBaseUrl ? WebService.IMAGE_BASE_URL + link : link
            guard let url = URL(string: strlink) else {
                return
            }

            if isIndicator {
                self.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.sd_imageIndicator?.startAnimatingIndicator()
            }

            if isFromCache {
                self.sd_setImage(with: url,
                                 placeholderImage: placeHolderImage,
                                 completed: { [weak self] (image, error, cacheType, url) -> Void in
                                     if error != nil {
                                      //debugPrint("\(self ?? UIImageView()) \(error!)")
                                    }

                                    self?.image = image ?? self?.image
                                    self?.sd_imageIndicator?.stopAnimatingIndicator()
                })
            }
            else {
                let shared = SDWebImageDownloader.shared
                shared.downloadImage(with: url,
                                     options: SDWebImageDownloaderOptions.ignoreCachedResponse,
                                     progress: nil,
                                     completed: { [weak self] (image, data, error, result) in
                                        if error != nil {
                                            //debugPrint("\(self ?? UIImageView()) \(error!)")
                                        }

                                        self?.image = image ?? self?.image
                                        self?.sd_imageIndicator?.stopAnimatingIndicator()
                })
            }
        }
    }
    
    
}

extension UIImage
{
     func jd_imageAspectScaled(toFit size: CGSize) -> UIImage {
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = size.width / size.height
        
        var resizeFactor: CGFloat
        
        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = size.width / self.size.width
        } else {
            resizeFactor = size.height / self.size.height
        }
        
        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (size.width - scaledSize.width) / 2.0, y: (size.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: origin, size: scaledSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIImage {

    func imageWithColor(color: UIColor = .themeImageColor) -> UIImage? {
            var image = withRenderingMode(.alwaysTemplate)
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            color.set()
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
            return image
        }
}




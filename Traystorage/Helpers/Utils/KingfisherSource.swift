//
//  KingfisherSource.swift
//  Traystorage
//
//



import Foundation
import ImageSlideshow
import Kingfisher


class KingfisherSource: InputSource {
    
    var url: String?
    public init(url: String) {
        self.url = url
    }
    func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void) {
        guard let urlString = url, let imageURL = URL(string: urlString) else {
            callback(nil)
            return
        }
        imageView.kf.setImage(with: imageURL, placeholder: nil, options: nil) { result in
            
            switch result {
            case .success(let ret):
                callback(ret.image)
                break
            case .failure(let err):
                callback(nil)
                print(err)
                break
            }
        }
    }
    
    func cancelLoad(on imageView: UIImageView) {
        imageView.kf.cancelDownloadTask()
    }
}

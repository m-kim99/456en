//
//  ImageBrowserVC.swift
//  Traystorage
//
//

import Foundation
import ImageSlideshow

class ImageSlideViewVC: BaseVC {
    @IBOutlet weak var imageSliderView: ImageSlideshow!
    @IBOutlet weak var pageIndicator: UILabel!
    
    var modelDocument: ModelDocument!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSliderView.delegate = self
        var images = [InputSource]()
        for item in modelDocument.images {
            if let url = item["url"] as? String {
                images.append(KingfisherSource(url: url))
            } else if let image = item["image"] as? UIImage {
                images.append(ImageSource(image: image))
            }
        }
        
        imageSliderView.setImageInputs(images)
        pageIndicator.text = "1/\(images.count)"
    }
    
}

extension ImageSlideViewVC: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        pageIndicator.text = "\(page+1)/\(imageSlideshow.images.count)"
    }
}

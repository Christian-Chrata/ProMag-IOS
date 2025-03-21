//
//  LoadingController.swift
//  Common
//
//  Created by Christian Wiradinata on 08/01/23.
//

import UIKit

public class LoadingController {
    private weak var parentView: UIView!
    private var overlay: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        return view
    }()
    private let loadingImage: UIImageView = {
        let image = UIImageView()
        if let bundle = Bundle(identifier: "com.chrata.Common"),
           let path = bundle.path(forResource: "loading", ofType: "gif") {
            let url = URL(fileURLWithPath: path)
            if let gifData = try? Data(contentsOf: url),
                let source =  CGImageSourceCreateWithData(gifData as CFData, nil) {
                var images = [UIImage]()
                let imageCount = CGImageSourceGetCount(source)
                for i in 0 ..< imageCount {
                    if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                        images.append(UIImage(cgImage: image))
                    }
                }
                image.animationImages = images
                image.animationDuration = 1.5
            }
        }
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private static var _shared: LoadingController = LoadingController()
    public class var shared: LoadingController {
        return _shared
    }
    
    public func show() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self,
            let window = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first else {
                return
            }
            self.parentView = window
            self.parentView.addSubview(self.overlay)
            self.overlay.addSubview(self.loadingImage)
            self.overlay.layer.zPosition = 1
            self.loadingImage.centerXAnchor.constraint(equalTo: self.parentView.centerXAnchor).isActive = true
            self.loadingImage.centerYAnchor.constraint(equalTo: self.parentView.centerYAnchor).isActive = true
            self.loadingImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
            self.loadingImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
            self.loadingImage.startAnimating()
        }
    }
    
    public func dismiss() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.loadingImage.stopAnimating()
            self.overlay.removeFromSuperview()
        }
    }
}

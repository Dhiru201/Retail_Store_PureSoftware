//
//  ImageDownloader.swift
//  Retail_Store_Puresoftware
//
//  Created by Dhirendra Kumar Verma on 28/06/24.
//

import UIKit

/// A utility class for downloading images from a given URL asynchronously.
public class ImageDownloader {
    
    /// Downloads an image from the specified URL.
    /// - Parameters:
    ///  - url: The URL of the image to download.
    ///  - completion: The completion handler to call when the download is complete, providing the downloaded image or `nil` if an error occurs.
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(UIImage(named: Constants.noImageIcon))
                return
            }
            completion(image)
        }.resume()
    }
}


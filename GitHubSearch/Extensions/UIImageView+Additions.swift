//
//  UIImageView+Additions.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/13/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func load(url: URL, completion: ((Bool) -> Void)? = nil) -> URLSessionDataTask? {
        // set initial image to nil so it doesn't use the image from a reused cell
        image = nil

        // download the image asynchronously
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion?(false)
                return
            }

            DispatchQueue.main.async {
                // create UIImage
                if let data = data,
                    let image = UIImage(data: data) {
                    self.image = image
                }
            }
        }
        task.resume()
        return task
    }
}

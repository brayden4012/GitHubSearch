//
//  UIImageView+Additions.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/13/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func load(url: URL, completion: ((Bool) -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { completion?(false); return }
            if let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                    completion?(true)
                }
            } else {
                completion?(false)
            }
        }
    }
}

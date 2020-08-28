//
//  GuessLoginData.swift
//  Space Riot
//
//  Created by alex on 27.08.20.
//  Copyright © 2020 alex. All rights reserved.
//

import Foundation
import UIKit

struct GuessLoginData {
    static var userPhoto: UIImage = {
        var item = UIImage(imageLiteralResourceName: "Space-Riot-Assets/Main-Menu/profile/Guest icons/blueguest-icons")
        item = GuessLoginData.maskRoundedImage(image: item, radius: item.size.width/2)
        return item
    }()
    static var fullName: String?
    
    static func convertImageToData(){
        if var data = GuessLoginData.userPhoto.pngData(){
            var documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var url = documents.appendingPathComponent("guessUserPhoto.png")
        }
    }
    
    static func maskRoundedImage(image: UIImage, radius: CGFloat) -> UIImage {
        let imageView: UIImageView = UIImageView(image: image)
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }
}

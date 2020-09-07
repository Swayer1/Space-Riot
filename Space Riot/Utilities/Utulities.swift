//
//  Utulities.swift
//  Space Riot
//
//  Created by alex on 30.08.20.
//  Copyright © 2020 alex. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Utilities{
    static func SaveFacebookDataToDevice(){
        var defaults = UserDefaults()
        var imageData: NSData = FacebookLoginData.userPhoto!.pngData() as! NSData
        defaults.set(imageData, forKey: "facebookImageData")
        defaults.set(FacebookLoginData.fullName!, forKey: "facebookNameData")
        defaults.set(FacebookLoginData.email!, forKey: "facebookEmailData")
    }
    
    static func LoadFacebookDataToDevice(){
        var defaults = UserDefaults()
        FacebookLoginData.userPhoto = UIImage(data: defaults.data(forKey: "facebookImageData")!)
        FacebookLoginData.fullName = defaults.string(forKey: "facebookNameData")
        FacebookLoginData.email = defaults.string(forKey: "facebookEmailData")
    }

    static func AddChild(scene: SKScene, item: SKNode){
        if(scene.childNode(withName: item.name!) == nil){
            scene.addChild(item)
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

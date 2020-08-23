//
//  FacebookLoginData.swift
//  Space Riot
//
//  Created by alex on 14.08.20.
//  Copyright © 2020 alex. All rights reserved.
//

import Foundation
import UIKit

struct FacebookLoginData {
    static var userPhoto: UIImage? = UIImage()
    static var fullName: String? = ""
    static var friendsList: [String]? = []
    
    func convertImageToData(){
        if var data = FacebookLoginData.userPhoto?.pngData(){
            var documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var url = documents.appendingPathComponent("facebookUserPhoto.png")
        }
    }
}

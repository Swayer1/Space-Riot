//
//  FacebookLoginData.swift
//  Space Riot
//
//  Created by alex on 14.08.20.
//  Copyright © 2020 alex. All rights reserved.
//

import Foundation
import UIKit

class FacebookLoginData: Codable {
    static var userPhoto: UIImage?
    static var fullName: String?
    static var email: String?
    static var friendsList: [String]?        
}

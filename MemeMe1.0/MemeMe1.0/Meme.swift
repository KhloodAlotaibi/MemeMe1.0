//
//  Meme.swift
//  MemeMe1.0
//
//  Created by Khlood on 5/10/20.
//  Copyright © 2020 Khlood. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topTextField = ""
    var bottomTextField = ""
    var originalImage: UIImage
    var combinedImage: UIImage
    
    init(topText: String, bottomText: String, orgImage: UIImage, memeImage: UIImage) {
        topTextField = topText
        bottomTextField = bottomText
        originalImage = orgImage
        combinedImage = memeImage
    }
}

//
//  unsplash.Swift
//  passionProject
//
//  Created by C4Q on 5/20/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

struct firstWrapper: Codable {
    let urls: URLS
}
struct URLS: Codable {
    let regular: String
    let small: String
}

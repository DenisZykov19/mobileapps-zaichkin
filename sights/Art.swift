//
//  Art.swift
//  sights
//
//  Created by WSR on 6/24/19.
//  Copyright © 2019 WSR. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

class Art: Object {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

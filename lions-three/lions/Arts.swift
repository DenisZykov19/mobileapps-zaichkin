//
//  Arts.swift
//  lions
//
//  Created by Администратор on 24/06/2019.
//  Copyright © 2019 Sergey Klimovich. All rights reserved.
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

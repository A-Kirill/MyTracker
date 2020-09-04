//
//  Coordinate.swift
//  MyTracker
//
//  Created by Kirill Anisimov on 04.09.2020.
//  Copyright © 2020 Kirill Anisimov. All rights reserved.
//

import Foundation
import RealmSwift


class Coordinate: Object {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var id: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

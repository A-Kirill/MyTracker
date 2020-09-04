//
//  DBManager.swift
//  MyTracker
//
//  Created by Kirill Anisimov on 04.09.2020.
//  Copyright © 2020 Kirill Anisimov. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    
 static let instance = DBManager()
    private init() {}
    
    func addRouteToDb(_ track: [Coordinate]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            for point in track {
                realm.add(point)
            }
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func removeRouteFromDb() {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.deleteAll()
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    func loadTrackPointArrayFromDb() -> [Coordinate] {
        do {
            let realm = try Realm()
            return Array(realm.objects(Coordinate.self))
        } catch {
            print(error)
            return []
        }
    }
}

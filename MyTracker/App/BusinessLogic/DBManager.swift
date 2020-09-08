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
    
    // MARK: - Route actions
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
    
    
    // MARK: - User actions
    func registerUser(login: String, password: String) -> Bool {
        let user = User(value: [login, password])
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(user, update: .all)
            try realm.commitWrite()
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func checkUser(login: String, password: String) -> Bool {
        var result = false
        do {
            let realm = try Realm()
            let users = Array(realm.objects(User.self).filter("login = '\(login)' AND password = '\(password)'"))
            result = users.count > 0
        } catch {
            print(error)
        }
        return result
    }
    
}

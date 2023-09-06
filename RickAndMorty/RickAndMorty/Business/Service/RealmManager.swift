//
//  RealmManager.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 5/9/23.
//

import Foundation
import RealmSwift

open class RealmManager {
    
    public let realm = try? Realm()

    public init(){
       
    }
    
    public func saveObject(cacheObject: RealmCacheObject) -> Bool {
        do {
            guard let realm = realm else { return false }
            try realm.write {
                realm.add(cacheObject, update: .all)
            }
            return true
            
        } catch let error as NSError {
            print(error.description)
            return false
        }
    }
    
    // MARK: Fetch
    public func fetchObjects(url: String) -> Data? {
        guard let realm = realm else { return nil }
        let cacheObject =  realm.object(ofType: RealmCacheObject.self, forPrimaryKey: url)
        return cacheObject?.serviceData
    }
    
    public func fetchAllObjects() {
        guard let realm = realm else { return }
        let obkects =  realm.objects(RealmCacheObject.self)
        print(obkects)
    }
    
}

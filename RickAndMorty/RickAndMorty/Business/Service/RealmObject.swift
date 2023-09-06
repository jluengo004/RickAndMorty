//
//  RealmObject.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 5/9/23.
//

import Foundation
import RealmSwift

open class RealmCacheObject: Object {
    @objc dynamic var url: String?
    @objc dynamic var serviceData: Data?
    
    public init(serviceData: Data, url: String) {
        self.serviceData = serviceData
        self.url = url
    }
    
    required public override init() {}
    
    open override class func primaryKey() -> String? {
        return "url"
    }
}

//
//  PlaceModel.swift
//  myCoffeeMap
//
//  Created by Максим Сулим on 28.01.2023.
//

import RealmSwift

class Place: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var lacation: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
           
    convenience init(name: String, lacation: String?, type: String?, imageData: Data?) {
        self.init()
        self.name = name
        self.lacation = lacation
        self.type = type
        self.imageData = imageData
    }
    
    }

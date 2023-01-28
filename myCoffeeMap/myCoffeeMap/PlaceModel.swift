//
//  PlaceModel.swift
//  myCoffeeMap
//
//  Created by Максим Сулим on 28.01.2023.
//

import Foundation

struct Place {
    
    var name : String
    var lacation : String
    var type : String
    var image : String

    static let restaurantName = [ "She", "TOTO", "Hello Aster", "Civil", "Verle", "ZOE", "Tiger lily", "Ezo"]
    
    static func getPlaces() -> [Place] {
        
        var places = [Place]()
        
        for place in restaurantName {
            places.append(Place(name: place, lacation: "Moscow", type: "kaif", image: place))
        }
        
        return places
    }
}
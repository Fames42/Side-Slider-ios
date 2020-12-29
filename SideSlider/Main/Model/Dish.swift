//
//  Dish.swift
//  SideSlider
//
//  Created by Admin on 12/29/20.
//
import Foundation

struct Dish {
    var name: String?
    var price: String?
    var description: String?
    var tags: [String]?
    var id: String?
    
    init(name: String?, price: String?, description: String?, tags: [String]?, id: String?) {
        self.name = name
        self.price = price
        self.description = description
        self.tags = tags
        self.id = id
    }
}

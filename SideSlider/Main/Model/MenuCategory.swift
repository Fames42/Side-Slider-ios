//
//  MenuCategory.swift
//  SideSlider
//
//  Created by Admin on 12/29/20.
//

import Foundation

struct MenuCategory {
    var dishes: [Dish]
    var description: String?
    var name: String?
    
    init(name: String?, description: String?, dishes: [Dish]) {
        self.name = name
        self.description = description
        self.dishes = dishes
    }
    
}

//
//  AddCoffeeOrderViewModel.swift
//  CoffeeDict
//
//  Created by DHIKA ADITYA ARE on 18/01/22.
//

import Foundation

struct AddCoffeeOrderViewModel{
    
    var name: String?
    var total: Double?
    //    var email: String?
    
    var selectedProduct: String?
    var selectedSize: String?
    
    var products: [String]{
        return CoffeeType.allCases.map{ $0.rawValue.capitalized } //Dengan menggunakan AllCasses kia bisa mengakses semua case di CoffeType
    }
    
    var sizes: [String]{
        return CoffeeSize.allCases.map{ $0.rawValue.capitalized } //Karena kita ingin mengakses valuenya maka kita dapat memanfaatkan map dengan rawValue
    }
}

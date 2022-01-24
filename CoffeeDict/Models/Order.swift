//
//  Order.swift
//  CoffeeDict
//
//  Created by DHIKA ADITYA ARE on 13/01/22.
//

import Foundation

class OrderListViewModel{
    var orderViewModel: [OrderViewModel]
    
    init(){
        self.orderViewModel = [OrderViewModel]()
    }
}

enum CoffeeType: String, Codable, CaseIterable{
    case cappucino
    case latte
    case espressino
    case espresso
    case cortado
    case hotCoffee
}

enum CoffeeSize: String, Codable, CaseIterable{
    case small
    case medium
    case large
}

struct Order: Codable{
    let name: String
    let product: CoffeeType
    let total: Double
    let size: CoffeeSize

    enum CodingKeys: String, CodingKey{
        case name
        case product = "coffeeName"
        case total
        case size
    }
}


//MARK: - Convert addCoffeeViewModel ke Model
extension Order {
    //_ artinya kita gamau nambahin label di init
    init?(_ vm: AddCoffeeOrderViewModel){
        //MARK: Get All data
        guard let name = vm.name,
              let total = vm.total,
              let selectedType = CoffeeType(rawValue: vm.selectedProduct!.lowercased()),
              let selectedSize = CoffeeSize(rawValue: vm.selectedSize!.lowercased()) else {
                  return nil
              }
        self.name = name
        self.total = total
        self.size = selectedSize
        self.product = selectedType
    }
}


extension Order{
    //MARK: (Optional)Buat static variable untuk Resource
    static var all: Resources<[Order]> = {
        guard let urlTemp = URL(string: "https://island-bramble.glitch.me/orders") else {
            fatalError("URL is Incorrect")
        }

        return Resources<[Order]>(url: urlTemp)
    }()
    
    
    //MARK: - Resource ini akan di provide/disediakan untuk webService
    static func create(vm: AddCoffeeOrderViewModel) -> Resources<Order?>{
        let order = Order(vm)
        guard let url = URL(string: "https://island-bramble.glitch.me/orders") else {
            fatalError("URL is Incorrect")
        }
        
        //MARK: Step selanjutnya adalah menggunakan 'order' untuk meng create data.
        
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Error encoding order")
        }
        
        //MARK: Create new resource dan buat 'init url' di resources
        var resource = Resources<Order?>(url: url)
        
        //MARK: selanjutnya kasih tau resource kalau http methodnya harus POST
        resource.httpMethod = HttpMethod.post
        resource.body = data
        
        return resource
    }
}





//MARK: Append Original Data
//"name": "John Doe",
//"coffeeName": "Hot Coffee",
//"total": 4.5,
//"size": "Medium"


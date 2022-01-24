//
//  OrderViewModels.swift
//  CoffeeDict
//
//  Created by DHIKA ADITYA ARE on 13/01/22.
//

import Foundation

//MARK: - Parse More Data
class OrderListViewMode{
    var ordersViewModel: [OrderViewModel]
    
    init(){
        self.ordersViewModel = [OrderViewModel]() //inisiasi sebagai empty array
    }
}

extension OrderListViewMode{
    
    //Order data at index -> OrderViewModel
    func orderDataAtIndex(at index: Int) -> OrderViewModel{
        return self.ordersViewModel[index]
    }
}



//MARK: - Parse Single Data
struct OrderViewModel{
    let order: Order
}

//extension OrderViewModel{
//    init(_ order: Order) {
//        self.order = order
//    }
//}

extension OrderViewModel{
    var name: String{
        return self.order.name
    }
}

extension OrderViewModel{
    var product: String{
        return self.order.product.rawValue.capitalized
    }
}

extension OrderViewModel{
    var total: Double{
        return self.order.total
    }
}

extension OrderViewModel{
    var size: String{
        return self.order.size.rawValue.capitalized //untuk mengakomodate view
    }
}


//let name: String
//let product: String
//let total: Double
//let size: CoffeeSize

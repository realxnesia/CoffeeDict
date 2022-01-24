//
//  OrdersTableViewController.swift
//  CoffeeDict
//
//  Created by DHIKA ADITYA ARE on 13/01/22.
//

import UIKit

class OrdersTableViewController: UITableViewController {

    //MARK: - create viewmodel untuk supply datanya ke view di OrderListViewModel
    var orderListViewModel = OrderListViewMode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders() //isi order
    }

    
    private func populateOrders(){
        
/*
         //MARK: - Karena kita pakai static var di model untuk resource, maka kita tidak perlu menulis kode ulang yg sama
        guard let coffeeOrdersURL = URL(string: "https://island-bramble.glitch.me/orders") else {
            fatalError("URL was incorrect")        }
        
        let resource = Resources<[Order]>(url: coffeeOrdersURL)
*/
        
        //MARK: karena kita menggunakan self disini dan ini merupakan result dari web service, jadi pastikan self bernillai opsional dan buat [weak self]
        //Ganti resourcenya dari resource ke Order.all
        APIService().load(resource: Order.all) { [weak self] result in
            switch result{
            case .success(let orders):
                //print(orders)
                self?.orderListViewModel.ordersViewModel = orders.map(OrderViewModel.init) //pasing output 'order' ke ViewModel yg single
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
//     MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.orderListViewModel.ordersViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //ambil particullar order
        let vm = self.orderListViewModel.orderDataAtIndex(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        
        cell.textLabel?.text = vm.product
        cell.detailTextLabel?.text = vm.size
        
        return cell
    }
}

extension OrdersTableViewController: AddCoffeeOrderDelegate{
    
    //MARK: ketika button save ditekan, kita mau dapetin data ordernya.
    func addOrderViewControllerDidSaveButtonTapped(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        /*
        let orderVM = OrderViewModel(order: order)
        self.orderListViewModel.ordersViewModel.append(orderVM) //Add ke list
        
        //MARK: Add ke rows
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.ordersViewModel.count - 1, section: 0)], with: .automatic)
         */
        populateOrders()
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addOrderViewControllerDidCloseButtonTapped(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: dengan melakukan prepare segue, artinya kita diberikan akses ke destinasi controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //MARK: Karena di story board kita mengakses navigastion controller dulu dan tidak langusng mengakses AddOrderViewController maka kta perlu unwrap dan assign value seperti dibawah.
        guard let navController = segue.destination as? UINavigationController, let addCoffeOrderVC = navController.viewControllers.first as? AddOrderViewController else { fatalError("Error performing segue") }
        
        //MARK: Pasang delegate
        addCoffeOrderVC.delegate = self
    }
    
}

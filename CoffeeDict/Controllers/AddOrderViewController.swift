//
//  AddOrderViewController.swift
//  CoffeeDict
//
//  Created by DHIKA ADITYA ARE on 13/01/22.
//

import UIKit

protocol AddCoffeeOrderDelegate{
    func addOrderViewControllerDidSaveButtonTapped(order: Order, controller: UIViewController)
    func addOrderViewControllerDidCloseButtonTapped(controller: UIViewController)
}

class AddOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Add delegate here
    var delegate: AddCoffeeOrderDelegate?

    private var vm = AddCoffeeOrderViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var totalTextField: UITextField!
    private var coffeeSizeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.products.count
    }
    
    private func setupUI(){
        self.coffeeSizeSegmentedControl = UISegmentedControl(items: self.vm.sizes)
        //MARK: Position
        self.coffeeSizeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false //karena kita ingin apply constrainsts yg berbeda untuk posisi segmented control
        self.view.addSubview(self.coffeeSizeSegmentedControl) //tambahkan ke currntView
        //MARK: Apply constraint
        self.coffeeSizeSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true //set contraint based dari another constrain view yg lain dalam hal ini table view
        self.coffeeSizeSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true //buat posisinya jadi center dari viewnya.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
        
        cell.textLabel?.text = self.vm.products[indexPath.row]
        
        return cell
    }
    
    //MARK: Checkmark selected cell | Tapi ini bisa banyak table yg diselect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    //MARK: Hanya 1 cell saja yg di select (melengkapi checkmark semuanya)
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    
    @IBAction func didSaveButtonTapped(_ sender: UIBarButtonItem) {
        let name = self.nameTextField.text
        let total = self.totalTextField.text
        
        let selectedSize = self.coffeeSizeSegmentedControl.titleForSegment(at: self.coffeeSizeSegmentedControl.selectedSegmentIndex)
        
        guard let indexpath = self.tableView.indexPathForSelectedRow else{
            fatalError("error in select")
        }
        
        self.vm.name = name
        self.vm.total = Double(total ?? "0")
        //MARK: setting di view model untuk menampung selectedSize sama selectedProduct
        self.vm.selectedSize = selectedSize
        self.vm.selectedProduct = self.vm.products[indexpath.row]
        
        //MARK: disini kita ingin mengrim data model yg sudah di convert ke dalam view model. hal itu dapat kita lakukan setelah kita membuatau extension order untuk mempersiapkan RequestAPI
        APIService().post(resource: Order.create(vm: self.vm)) { result in
            switch result {
            case .success(let order):

                //MARK: unwrap order dan delegate serta implement delegate
                if let order = order, let delegate = self.delegate{
                    DispatchQueue.main.async {
                        delegate.addOrderViewControllerDidSaveButtonTapped(order: order, controller: self)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func didCloseButtonTapped(_ sender: Any) {
        if let delegate = delegate {
            delegate.addOrderViewControllerDidCloseButtonTapped(controller: self)
        }
    }
    
}

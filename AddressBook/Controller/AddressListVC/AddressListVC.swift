
//
//  AddressLustVC.swift
//  AddressBook
//
//  Created by MohiniPatel on 9/20/17.
//  Copyright © 2017 Differenz System. All rights reserved.
//

import UIKit
import CoreData
class AddressListVC: BaseView {
    
    //MARK: - IBoutlet
    @IBOutlet weak var tblAddress: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    //MARK: - variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var users = [User]()
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialConfig()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button action methods
    
    /**
     This method is used to handle logout button click.
        - Parameter sender: action button
     */
    @objc func logoutClick(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: Constant.UserDefaultsKey.IsLogin)
        self.appDelegate.setupRootView()
    }
    
    /**
     This method is used to handle add address button click.
        - Parameter sender: action button
     */
    @objc func addClick(_ sender: Any) {
        let addAddressVC = self.storyboard?.instantiateViewController(withIdentifier: Constant.VCIdetinfier.AddAddressVC) as! AddAddressVC
        addAddressVC.delegate = self
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
    
    //MARK: - Instance methods
    
    /**
     This method is used for initial configuration of Controller.
     */
    func initialConfig() {
        self.setUpNavigationBar()
        self.tblAddress.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        self.tblAddress.tableFooterView = UIView()
        self.tblAddress.estimatedRowHeight = 84
        self.tblAddress.rowHeight = UITableViewAutomaticDimension
        self.lblNoData.isHidden = true
        self.loadData()
    }
    
    /**
     This method is used to setup navigation bar.
     */
    
    func setUpNavigationBar() {
        self.title = "Address Book"
        self.navigationController?.navigationBar.tintColor = .white
        self.setLeftNavigationItem(with: "Logout", action: #selector(logoutClick(_:)))
        self.setRightNavigationItem(with: "Add", action: #selector(addClick(_:)))
    }
    
    /**
     This method is used to fetch data from CoreData.
     */
    
    func loadData() {
        let context: NSManagedObjectContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        //Get the context object
        if #available(iOS 10.0, *) {
            context = appDelegate.persistentContainer.viewContext
            
        } else {
            // Fallback on earlier versions
            context = appDelegate.managedObjectContext
        }
        
        //Fetch User list from CoreData
        self.users = try! context.fetch(fetchRequest)
        
        //Reload the table and show/hide the no data label
        self.tblAddress.reloadData()
        self.lblNoData.isHidden = !self.users.isEmpty
    }
}

//MARK: - UITableview Delegate and DataSource methods
extension AddressListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        
        //Set up user data in cell
        cell.lblName.text = self.users[indexPath.row].name
        cell.lblEmail.text = self.users[indexPath.row].email
        cell.lblContactNo.text = self.users[indexPath.row].contactno
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addAddressVC = self.storyboard?.instantiateViewController(withIdentifier: Constant.VCIdetinfier.AddAddressVC) as! AddAddressVC
        addAddressVC.editUser = self.users[indexPath.row]
        addAddressVC.editUserIndex = indexPath.row
        addAddressVC.delegate = self
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
}

//MARK: - EditAddressDelegate method
extension AddressListVC : AddressDelegate {
    func add(user: User) {
        self.users.append(user)
        self.lblNoData.isHidden = !self.users.isEmpty
        self.tblAddress.reloadData()
    }
    
    func replaceObject(at index: Int, with user: User) {
        self.users[index] = user
        self.tblAddress.reloadData()
    }
    
    func deleteUser(at index: Int) {
        self.users.remove(at: index)
        self.lblNoData.isHidden = !self.users.isEmpty
        self.tblAddress.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

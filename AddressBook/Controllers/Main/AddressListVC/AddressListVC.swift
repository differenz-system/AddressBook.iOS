
//
//  AddressLustVC.swift
//  AddressBook
//
//  Created by DifferenzSystem PVT. LTD. on 01/19/2021.
//  Copyright © 2021 Differenz System. All rights reserved.
//

import UIKit
import CoreData



class AddressListVC: BaseView {
    
    //MARK: - IBoutlet
    @IBOutlet weak var tblAddress: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var vwSearchBar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var vwImgBg: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    
    //MARK: - variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var users = [User]()
    var letters = [String]()
  
   
    var shouldShowSearchResults = false
  
    var names = [String]()
    var contacts = [String: [User]]()
    var contactsFiltered = [String: [User]]()
    var searchLetter = [String]()
   
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
            
        
        // Do any additional setup after loading the view.
        self.initialConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Instance methods
    
    /**
     This method is used for initial configuration of Controller.
     */
    func initialConfig() {
        
        let origImage = UIImage(named: "add")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        self.btnAdd.setImage(tintedImage, for: .normal)
        self.btnAdd.tintColor = .white
        self.searchBar.barTintColor = UIColor.gray
        self.searchBar.backgroundColor = UIColor.clear
        self.searchBar.layer.borderColor = searchBar.barTintColor?.cgColor
        self.searchBar.isTranslucent = true
        self.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .clear
        self.searchBar.setImage(UIImage(), for: .search, state: .normal)
        self.navigationController?.isNavigationBarHidden = true
        self.tblAddress.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        self.tblAddress.tableFooterView = UIView()
        self.tblAddress.estimatedRowHeight = 84
        self.tblAddress.rowHeight = UITableView.automaticDimension
        self.lblNoData.isHidden = true
        self.imgBg.roundBottomCorners(radius: 30)
        self.vwImgBg.roundBottomCorners(radius: 30)
        vwSearchBar.roundedBorder()
        
    }
    
    //MARK: - Button action methods
    
    /**
     This method is used to handle logout button click.
        - Parameter sender: action button
     */
    @IBAction func btnAddTouchUpInsite(_ sender: Any) {
        
        let addAddressVC = self.storyboard?.instantiateViewController(withIdentifier: Constant.VCIdetinfier.AddAddressVC) as! AddAddressVC
        addAddressVC.delegate = self
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
  
    /**
     This method is used to handle add address button click.
        - Parameter sender: action button
     */
    
    @IBAction func btnLogoutTouchUpInsite(_ sender: Any) {
        
        UserDefaults.standard.set(false, forKey: Constant.UserDefaultsKey.IsLogin)
        self.appDelegate.setupRootView()
        
    }
   
    
   
    
    
    func clearData() {
        self.users.removeAll()
        self.letters.removeAll()
        self.names.removeAll()
        self.contacts.removeAll()
    }
    
    
    /**
     This method is used to fetch data from CoreData.
     */
    
    func loadData() {
        self.clearData()
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
        
        //For contact display letter wise
        names = self.users.map{($0.name ?? "")}
        letters = names.map { (name) -> String in
            return name[name.startIndex].uppercased()
        }

        letters = letters.sorted()
        letters = letters.reduce([], { (list, name) -> [String] in
            if !list.contains(name) {
                return list + [name]
            }
            return list
        })
        
        for user in  self.users {
            
            if contacts.keys.contains(user.name?.prefix(1).uppercased() ?? "#") {
                contacts[user.name?.prefix(1).uppercased() ?? "#"]?.append(user)
            } else {
                contacts[user.name?.prefix(1).uppercased() ?? "#"] = [user]
            }
        }

        for (letter, users) in contacts {
            contacts[letter] = users.sorted{ $0.name?.uppercased() ?? "" < $1.name?.uppercased() ?? "" }
        }
        
        //Reload the table and show/hide the no data label
       self.tblAddress.reloadData()
       self.lblNoData.isHidden = !self.users.isEmpty
    }
}

//MARK: - UITableview Delegate and DataSource methods
extension AddressListVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return shouldShowSearchResults ? searchLetter.count: letters.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
      
        return shouldShowSearchResults ? searchLetter : letters
            
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return shouldShowSearchResults ? searchLetter[section]: letters[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.applyGradient()
        let label = UILabel.init(frame: CGRect(x: 10, y: 10, width: 50, height: 20))
        label.font = UIFont.boldSystemFont(ofSize: 16)
       
        label.text = shouldShowSearchResults ? searchLetter[section]: letters[section]
            
       
        headerView.addSubview(label)
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return contactsFiltered[searchLetter[section]]?.count ?? 0
            }
            else {
                return contacts[letters[section]]?.count ?? 0
            }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        if shouldShowSearchResults {
            cell.lblName.text = contactsFiltered[searchLetter[indexPath.section]]?[indexPath.row].name
            cell.lblEmail.text = contactsFiltered[searchLetter[indexPath.section]]?[indexPath.row].email
            cell.lblContactNo.text = contactsFiltered[searchLetter[indexPath.section]]?[indexPath.row].contactno
            }
            else {
                
                cell.lblName.text = contacts[letters[indexPath.section]]?[indexPath.row].name
                cell.lblEmail.text = contacts[letters[indexPath.section]]?[indexPath.row].email
                cell.lblContactNo.text = contacts[letters[indexPath.section]]?[indexPath.row].contactno
            }
        
        //Set up user data in cell
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addAddressVC = self.storyboard?.instantiateViewController(withIdentifier: Constant.VCIdetinfier.AddAddressVC) as! AddAddressVC
     
        addAddressVC.editUser = contacts[letters[indexPath.section]]?[indexPath.row]
        addAddressVC.editUserIndex = indexPath.row
        addAddressVC.editUserSection = indexPath.section
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
    
    func deleteUser(at index: Int ,at sectionIndex: Int) {
        self.users.remove(at: index)
        self.lblNoData.isHidden = !self.users.isEmpty
        self.tblAddress.reloadData()
    }
    
   
}

//MARK: - SearchNameDelegate method
extension AddressListVC : UISearchBarDelegate{
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     
        shouldShowSearchResults = true
        if searchText.isEmpty || searchText == "" {
            
            shouldShowSearchResults = false
            self.contactsFiltered = self.contacts
            self.tblAddress.isHidden = false
            self.lblNoData.isHidden = true
            self.searchBar.endEditing(true)
            self.vwSearchBar.endEditing(true)
            
        }
        
        else{
            
            searchLetter = Array(arrayLiteral: searchText.prefix(1).uppercased())

            //Make the array of first letter of serach text from the contacts array.
            let users : [User] = self.contacts[searchText.prefix(1).uppercased() ] ?? [User]()
           
            //Serachig through the first letter by name attribute from the users array.
            let filteredUser : [User] = users.filter({ ($0.name?.localizedCaseInsensitiveContains(searchText) ?? true)
            })
            
            //store the searched data in contactctsFiltered array.
            self.contactsFiltered[searchText.prefix(1).uppercased()] =  filteredUser
           
            //Check the serach data is available or not.
            if filteredUser.isEmpty  {
                self.tblAddress.isHidden = true
                self.lblNoData.isHidden = false
            }
            else{
                print("There is data")
                self.tblAddress.isHidden = false
                self.lblNoData.isHidden = true
            
            }
        }
        self.tblAddress.reloadData()
        
    }
    
}

//
//  ContextSearchViewController.swift
//  ToBoApp
//
//  Created by Min Kim on 10/18/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class ParentViewController: UITableViewController, UISearchResultsUpdating {
  
  @IBOutlet weak var footerView: UIView!
  var controller: ParentController!
  var themeController = ThemeController()
  let searchController = UISearchController(searchResultsController: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchController.searchResultsUpdater = self
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.sizeToFit()
    tableView.backgroundColor = themeController.backgroundColor
    footerView.backgroundColor = themeController.backgroundColor
    self.tableView.tableHeaderView = searchController.searchBar
    searchController.searchBar.barTintColor = themeController.backgroundColor
    searchController.searchBar.tintColor = themeController.mainTextColor
    if themeController.isDarkTheme {
      searchController.searchBar.keyboardAppearance = .dark
    } else {
      searchController.searchBar.keyboardAppearance = .light
    }
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
      controller?.searchResults(searchText)
    } else {
      controller?.filteredList = controller?.listOfParents
    }
    tableView.reloadData()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let numberOfRows = controller?.numberOfRowsInSection() else {return 0}
    return numberOfRows
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ParentCell", for: indexPath)
    let parent = controller?.returnCellLabel(indexPath.row)
    cell.textLabel?.text = parent
    cell.textLabel?.textColor = themeController.mainTextColor
    cell.backgroundColor = themeController.backgroundColor
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let indexPath = tableView.indexPathForSelectedRow else {return}//optional, to get from any UIButton for example
    guard let currentCell = tableView.cellForRow(at: indexPath) else {return}
    guard let parentString = currentCell.textLabel?.text else {return}
    controller.setChosenParent(parentString)
    controller.sendChosenParent()
    performSegue(withIdentifier: segueIdentifiers.unwindParentSegue, sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueIdentifiers.unwindParentSegue {
      
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    searchController.dismiss(animated: false, completion: nil)
  }
}



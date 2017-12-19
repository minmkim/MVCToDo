//
//  ContextSearchViewController.swift
//  ToBoApp
//
//  Created by Min Kim on 10/18/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class ContextSearchViewController: UITableViewController, UISearchResultsUpdating {
  
  @IBOutlet weak var footerView: UIView!
  lazy var controller = ContextController()
  var themeController = ThemeController()
  let searchController = UISearchController(searchResultsController: nil)
  var newContext = ""
  
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
      controller.searchResults(searchText)
    } else {
      controller.filteredList = controller.listOfContext
    }
    tableView.reloadData()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfRows = controller.numberOfRowsInSection()
    return numberOfRows
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "contextCell", for: indexPath)
    let context = controller.returnCellLabel(indexPath.row)
    cell.textLabel?.text = context
    cell.textLabel?.textColor = themeController.mainTextColor
    cell.backgroundColor = themeController.backgroundColor
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let indexPath = tableView.indexPathForSelectedRow else {return}//optional, to get from any UIButton for example
    guard let currentCell = tableView.cellForRow(at: indexPath) else {return}
    guard let contextString = currentCell.textLabel?.text else {return}
    controller.setChosenContext(contextString)
    performSegue(withIdentifier: segueIdentifiers.unwindContextSegue, sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueIdentifiers.unwindContextSegue {
      let destination = segue.destination as! AddItemTableViewController
      controller.delegate = destination.controller as ChosenContextDelegate
      controller.sendContext()
    }
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    controller.removeContext(indexPath.row)
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
    tableView.reloadData()
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


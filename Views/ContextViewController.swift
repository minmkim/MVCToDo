//
//  ContextSearchViewController.swift
//  ToBoApp
//
//  Created by Min Kim on 10/18/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit

class ContextSearchViewController: UITableViewController, UISearchResultsUpdating {
  
  let searchController = UISearchController(searchResultsController: nil)
  var listToUse: [String]?
  var filteredList: [String]?
  var newList: [String]?
  var newContext = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    filteredList = listToUse
    if let newList = listToUse {
      print("newList \(newList)")
    }
    
    searchController.searchResultsUpdater = self
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.sizeToFit()
    self.tableView.tableHeaderView = searchController.searchBar
    
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
      filteredList = listToUse?.filter { context in
        return context.lowercased().contains(searchText.lowercased())
      }
      filteredList! += ["Create: " + searchText]
    } else {
      filteredList = listToUse
    }
    tableView.reloadData()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let contextList = filteredList else {
      return 0
    }
    
    return contextList.count
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "contextCell", for: indexPath)
    
    if let contextList = filteredList {
      let context = contextList[indexPath.row]
      cell.textLabel?.text = context
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let indexPath = tableView.indexPathForSelectedRow else {return}//optional, to get from any UIButton for example
    guard let currentCell = tableView.cellForRow(at: indexPath) as? UITableViewCell else {return}
    guard let label = currentCell.textLabel?.text else {return}
    if label.hasPrefix("Create") {
      print("Label is \(label)")
      newContext = String(label.dropFirst(8))
      
      print("newContext is \(newContext)")
      listToUse! += ["\(newContext)"]
      performSegue(withIdentifier: "unwindSegue", sender: self)
    } else {
      print("Label2 is \(label)")
      newContext = label
      performSegue(withIdentifier: "unwindSegue", sender: self)
      
    }
    
    
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    let indexPaths = [indexPath]
    listToUse!.remove(at: indexPath.row)
    filteredList!.remove(at: indexPath.row)
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


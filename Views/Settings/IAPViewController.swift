//
//  IAPViewController.swift
//  DueLife
//
//  Created by Min Kim on 10/23/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit
import StoreKit

class IAPViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

  var productID = ""
  var productsRequest = SKProductsRequest()
  var iapProducts = [SKProduct]()
  var themeController = ThemeController()
  
  @IBOutlet weak var descriptionLabel: UILabel!
  var product_id: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = themeController.backgroundColor
    descriptionLabel.textColor = themeController.mainTextColor
    
    product_id = "com.minkim.DueLife.removeLimit"
  }
  //  Unlock Content: This is button action which will initialize purchase
  
  @IBAction func unlockAction(_ sender: Any) {
    print("About to fetch the product...")
    // Can make payments
    if (SKPaymentQueue.canMakePayments())
    {
      let productID:NSSet = NSSet(object: self.product_id!);
      let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
      productsRequest.delegate = self;
      productsRequest.start();
      print("Fetching Products");
    }else{
      print("Can't make purchases");
    }
  }
  
  @IBAction func restorePurchaseButt(_ sender: Any) {
    SKPaymentQueue.default().add(self)
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
  
  
  
  func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    print("Attempting to restore")
    
    let transactionCount = queue.transactions.count
    
    if transactionCount == 0 {
      let alertController = UIAlertController(title: "Already restored!", message: "You have already unlocked the app", preferredStyle: UIAlertControllerStyle.alert)
      let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        print("OK")
      }
      alertController.addAction(okAction)
      self.present(alertController, animated: true, completion: nil)
    } else {
      UserDefaults.standard.set(true, forKey: "purchased")
      let alertController = UIAlertController(title: "Restored!", message: "You have successfully unlocked the app", preferredStyle: UIAlertControllerStyle.alert)
      let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        print("OK")
      }
      alertController.addAction(okAction)
      self.present(alertController, animated: true, completion: nil)
    }
    
    
  }
  
  //  Helper Methods
  
  func buyProduct(product: SKProduct){
    print("Sending the Payment Request to Apple");
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
  }
  
  func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    
    let count : Int = response.products.count
    if (count>0) {
      let validProduct: SKProduct = response.products[0] as SKProduct
      if (validProduct.productIdentifier == self.product_id) {
        print(validProduct.localizedTitle)
        print(validProduct.localizedDescription)
        print(validProduct.price)
        buyProduct(product: validProduct);
      } else {
        print(validProduct.productIdentifier)
      }
    } else {
      print("nothing")
    }
  }
  
  
  func request(_ request: SKRequest, didFailWithError error: Error) {
    print("Error Fetching product information");
  }
  
  func paymentQueue(_ queue: SKPaymentQueue,
                    updatedTransactions transactions: [SKPaymentTransaction])
    
  {
    print("Received Payment Transaction Response from Apple");
    
    for transaction:AnyObject in transactions {
      if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
        switch trans.transactionState {
        case .purchased:
          print("Product Purchased");
          SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
          // Handle the purchase
          UserDefaults.standard.set(true , forKey: "purchased")
          print(UserDefaults.standard.bool(forKey: "purchased"))
          //adView.hidden = true
          break;
        case .failed:
          print("Purchased Failed");
          SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
          let alertController = UIAlertController(title: "Failed!", message: "Sorry the transcation has failed. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
          let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("OK")
          }
          alertController.addAction(okAction)
          self.present(alertController, animated: true, completion: nil)
          break;
        case .restored:
          print("Already Purchased");
          SKPaymentQueue.default().restoreCompletedTransactions()
          
          // Handle the purchase
          UserDefaults.standard.set(true , forKey: "purchased")
          //adView.hidden = true
          break;
        default:
          break;
        }
      }
    }
    print(UserDefaults.standard.bool(forKey: "purchased"))
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}


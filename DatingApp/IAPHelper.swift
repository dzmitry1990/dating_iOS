/*
* Copyright (c) 2016 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import StoreKit
import UIKit


public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()

open class IAPHelper : NSObject  {
     
  var selectedProductID = ""
    var controller:UIViewController?
    
  static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
  fileprivate let productIdentifiers: Set<ProductIdentifier>
  fileprivate var purchasedProductIdentifiers = Set<ProductIdentifier>()
  fileprivate var productsRequest: SKProductsRequest?
  fileprivate var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
  var appDelegate = UIApplication.shared.delegate as! AppDelegate

  public init(productIds: Set<ProductIdentifier>) {
    productIdentifiers = productIds
    for productIdentifier in productIds {
      let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
      if purchased {
        purchasedProductIdentifiers.insert(productIdentifier)
        print("Previously purchased: \(productIdentifier)")
      } else {
        print("Not purchased: \(productIdentifier)")
      }
    }
    super.init()
    SKPaymentQueue.default().add(self)
  }
  
}

// MARK: - StoreKit API

extension IAPHelper {

  public func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
    productsRequest?.cancel()
    productsRequestCompletionHandler = completionHandler

    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
    productsRequest!.delegate = self
    productsRequest!.start()
  }

  public func buyProduct(_ product: SKProduct) {
    print("Buying \(product.productIdentifier)...")
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
    
    selectedProductID = product.productIdentifier
  }

  public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
    return purchasedProductIdentifiers.contains(productIdentifier)
  }
  
  public class func canMakePayments() -> Bool {
    return SKPaymentQueue.canMakePayments()
  }
  
  public func restorePurchases() {
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {

  public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    let products = response.products
    print("Loaded list of products...")
    productsRequestCompletionHandler?(true, products)
    clearRequestAndHandler()

    for p in products {
      print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
    }
  }
  
  public func request(_ request: SKRequest, didFailWithError error: Error) {
    print("Failed to load list of products.")
    print("Error: \(error.localizedDescription)")
    productsRequestCompletionHandler?(false, nil)
    clearRequestAndHandler()
  }

  private func clearRequestAndHandler() {
    productsRequest = nil
    productsRequestCompletionHandler = nil
  }
}

// MARK: - SKPaymentTransactionObserver
 
extension IAPHelper: SKPaymentTransactionObserver {
 
  public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      switch (transaction.transactionState) {
      case .purchased:
        complete(transaction: transaction)
        break
      case .failed:
        fail(transaction: transaction)
        break
      case .restored:
        restore(transaction: transaction)
        break
      case .deferred:
        break
      case .purchasing:
        break
      }
    }
  }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        //restore(transaction: transaction)
        var info:[String:Any] = [:]
        info["transaction"] = transaction.payment.productIdentifier
        
       // deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
       NotificationCenter.default.post(name: Notification.Name("paymentsuccess"), object: info)
        
//        if(selectedProductID == SubsCriptionKey.monthlySubscription)
//        {
//            self.addSubscriptionAPI(AppKey.monthlyKey, _strProductPrice: AppKey.monthlySubscriptionPrice)
//            
//        }
//        else if (selectedProductID == SubsCriptionKey.yearlySubscription)
//        {
//            self.addSubscriptionAPI(AppKey.yearlyKey, _strProductPrice: AppKey.yearlySubscriptionPrice)
//        }
    }
    
    func addSubscriptionAPI(_ strproductID: String, _strProductPrice: String) {
       
        let dict : NSDictionary = ["product_id" : strproductID , "productPrice" : _strProductPrice]
        
         NotificationCenter.default.post(name: Notification.Name("paymentsuccess"), object: dict )
    }
    
  private func restore(transaction: SKPaymentTransaction) {
    guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
    print("restore... \(productIdentifier)")
    deliverPurchaseNotificationFor(identifier: productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
  }
 
  private func fail(transaction: SKPaymentTransaction) {
    
    print("fail...")
    if let transactionError = transaction.error as NSError? {
      if transactionError.code != SKError.paymentCancelled.rawValue {
       // Utilities.alertView(controller: appDelegate.controller!, title: "", msg: (transaction.error?.localizedDescription)!)
        print("Transaction Error: \(transaction.error?.localizedDescription ?? "")")
        
      }
    }
 
    var info:[String:Any] = [:]
    info["error"] = transaction.error?.localizedDescription
    SKPaymentQueue.default().finishTransaction(transaction)
    NotificationCenter.default.post(name: Notification.Name("noPaymentsuccess"), object: info)
  }
 
  private func deliverPurchaseNotificationFor(identifier: String?) {
    guard let identifier = identifier else { return }
 
    purchasedProductIdentifiers.insert(identifier)
    UserDefaults.standard.set(true, forKey: identifier)
    UserDefaults.standard.synchronize()
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: identifier)
  }
  
    
    //Step 1 Call from button Restore Purchase
    func restore() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
//    //Step 2 Get transactions
//    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//
//        for transaction in transactions {
//
//            switch transaction.transactionState {
//            case .purchased:
//                print("Product Purchased")
//                // unlockApp()
//                SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//
//                break;
//            case .failed:
//                print("Purchased Failed");
//                SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                break;
//            case .restored:
//                print("Already Purchased")
//                // unlockApp()
//
//                SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//            default:
//                break
//            }
//        }
//    }
    
    
    
    
    //If an error occurs, the code will go to this function
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print(error.localizedDescription)
        //Handle Error
    }
    
}

// GCHelper.swift (v. 0.1)
//
// Copyright (c) 2015 Jack Cook
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import StoreKit

protocol FunkyPiDevIAPDelegate {
    func buyIAP()
    func restoreIAP()
    func buyProduct(product: SKProduct)
}

class FunkyPiDevIAP: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var product_id: NSString?;
    
    override init() {
        super.init()
        product_id = config.iapProductID
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }

    
    class var sharedInstance: FunkyPiDevIAP {
        struct Static {
            static let instance = FunkyPiDevIAP()
        }
        return Static.instance
    }
    
    
    // MARK: User functions
    
    func buyIAP(){
        println("About to fetch the products");
        // We check that we are allow to make the purchase.
        if (SKPaymentQueue.canMakePayments())
        {
            var productID:NSSet = NSSet(object: self.product_id!);
            var productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>);
            productsRequest.delegate = self;
            productsRequest.start();
            println("Fetching Products");
        }else{
            println("can't make purchases");
        }
    }
    
    func restoreIAP(){
        println("About to fetch the products");
        // We check that we are allow to make the purchase.
        if (SKPaymentQueue.canMakePayments())
        {
            var productID:NSSet = NSSet(object: self.product_id!);
            var productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>);
            productsRequest.delegate = self;
            productsRequest.start();
            println("Fetching Products");
        }else{
            println("can't make purchases");
        }
    }

    
    
    
    // Helper Methods
    
    func buyProduct(product: SKProduct){
        println("Sending the Payment Request to Apple");
        var payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment);
        
    }

    
    // MARK: delegate functions
    
    func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        println("got the request from Apple")
        var count : Int = response.products.count
        if (count>0) {
            var validProducts = response.products
            var validProduct: SKProduct = response.products[0] as! SKProduct
            if (validProduct.productIdentifier == self.product_id) {
                println(validProduct.localizedTitle)
                println(validProduct.localizedDescription)
                println(validProduct.price)
                buyProduct(validProduct);
            } else {
                println(validProduct.productIdentifier)
            }
        } else {
            println("nothing")
        }
    }
    
    
    func request(request: SKRequest!, didFailWithError error: NSError!) {
        println("fail");
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!)    {
        println("Received Payment Transaction Response from Apple");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .Purchased:
                    println("Product Purchased");
                    
                    var unlocked = true
                    let defaults = NSUserDefaults.standardUserDefaults()
                    //defaults.setObject(pCount, forKey: "playerChoice")
                    defaults.setBool(unlocked, forKey: "unlockedKey")
                    

                    
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    actInd.stopAnimating()
                    break;
                case .Failed:
                    println("Purchased Failed");
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    actInd.stopAnimating()
                    break;
                case .Restored:
                    var unlocked = true
                    let defaults = NSUserDefaults.standardUserDefaults()
                    //defaults.setObject(pCount, forKey: "playerChoice")
                    defaults.setBool(unlocked, forKey: "unlockedKey")
                    actInd.stopAnimating()
                    break;
                default:
                    break;
                }
            }
        }
        
    }
    
}

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
*/  //public static let monthlySubscription =  "com.razeware.rageswift3.GirlfriendOfDrummerRage"


import Foundation

public struct RageProducts {
    
    public  static let oneMonthAutoRenew = "com.app.Mydateapp.AutoRenewing.1Month"
    public  static let threeMonthAutoRenew = "com.app.Mydateapp.AutoRenewing.3Month"
    public  static let sixMonthAutoRenew = "com.app.Mydateapp.AutoRenewing.6Month"
    public  static let tweleveMonthAutoRenew = "com.app.Mydateapp.AutoRenewing.12Month"
    public  static let fiveYearAutoRenew = "com.app.Mydateapp.AutoRenewing.5Year"
    public  static let oneMonthNonRenew = "com.app.Mydateapp.NonRenewing.1Month"
    public  static let threeMonthNonRenew = "com.app.Mydateapp.NonRenewing.3Month"
    public  static let sixMonthNonRenew = "com.app.Mydateapp.NonRenewing.6Month"
    public  static let tweleveMonthNonRenew = "com.app.Mydateapp.NonRenewing.12Month"
    public  static let fiveYearNonRenew = "com.app.Mydateapp.NonRenewing.5Year"
    public  static let backWard = "com.app.Mydateapp.LifeTimeSubscription"
    //public  static let backWard1 = "com.app.Mydateapp.LifeTimeSubscriptions"

    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [RageProducts.oneMonthAutoRenew, RageProducts.threeMonthAutoRenew, RageProducts.sixMonthAutoRenew, RageProducts.tweleveMonthAutoRenew, RageProducts.fiveYearAutoRenew, RageProducts.oneMonthNonRenew, RageProducts.threeMonthNonRenew, RageProducts.sixMonthNonRenew, RageProducts.tweleveMonthNonRenew, RageProducts.fiveYearNonRenew, RageProducts.backWard
    ]

  public static let store = IAPHelper(productIds: RageProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}

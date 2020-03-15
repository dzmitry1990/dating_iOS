
import UIKit

class TermsAndConditionsViewController: UIViewController,hideMenu {
    
    @IBOutlet var webView: UIWebView!
    var flag:Int?

    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var titleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (flag == 0){
            let url = NSURL (string: "http://13.211.58.29/dating/users/privacy_policy?type=0")
            let requestObj = URLRequest(url: url! as URL)
            webView.loadRequest(requestObj)
            titleLbl.text = "Refund"
        }
        else if (flag == 1){
            let url = NSURL (string: "http://13.211.58.29/dating/users/privacy_policy?type=1")
            let requestObj = URLRequest(url: url! as URL)
            webView.loadRequest(requestObj)
            titleLbl.text = "Terms And Conditions"
        }
        else if (flag == 2){
            let url = NSURL (string: "http://13.211.58.29/dating/users/privacy_policy?type=2")
            let requestObj = URLRequest(url: url! as URL)
            webView.loadRequest(requestObj)
            titleLbl.text = "Privacy Policy"
        }
        else if (flag == 3){
            let url = NSURL (string: "http://13.211.58.29/dating/users/privacy_policy?type=3")
            let requestObj = URLRequest(url: url! as URL)
            webView.loadRequest(requestObj)
            titleLbl.text = "Subscription Detail"
        }
        else if (flag == 4){
            let url = NSURL (string: "http://13.211.58.29/dating/users/privacy_policy?type=4")
            let requestObj = URLRequest(url: url! as URL)
            webView.loadRequest(requestObj)
            titleLbl.text = "Legal Disclaimer"
        }
        
        
        else if (flag == 5){
            let url = NSURL (string: "https://pdai1.com/privacy/")
            let requestObj = URLRequest(url: url! as URL)
            webView.loadRequest(requestObj)
            titleLbl.text = "Privacy Policy"
        }
        
        else if (flag == 6){
            let url = NSURL (string: "https://pdai1.com")
            let requestObj = URLRequest(url: url! as URL)
            webView.loadRequest(requestObj)
            titleLbl.text = "Support"
        }
        
    }

     //MARK -: IBACTIONS
    @IBAction func backPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        menuBtn.isEnabled = false
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.hideMenus = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        }, completion:nil)
    }
    
    func hide() {
       menuBtn.isEnabled = true
    }
    
    //MARK: - WEBVIEW DELEGATE
    func webViewDidStartLoad(_ webView: UIWebView) {
        Utilities.showProgressView(view: self.view)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        Utilities.hideProgressView(view: self.view)
    }
    
}

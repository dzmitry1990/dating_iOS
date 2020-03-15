
import UIKit

class TermAndConditionViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pdf = Bundle.main.url(forResource: "terms&conditions", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
            webView.loadRequest(req as URLRequest)
        }
        
    }
    
    //MARK: - IBACTIONS
    @IBAction func menuBtnPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
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

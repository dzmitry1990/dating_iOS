
import UIKit
import MessageUI

class SuggestionsViewController: UIViewController,UITextViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,hideMenu {
    
    
    @IBOutlet var txtView: UITextView!
    
    @IBOutlet var menuBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtView.textColor = UIColor.lightGray
    }
    
    //MARK: - IBACTIONS
    @IBAction func backPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    
    @IBAction func emailBtnPressed(_ sender: Any) {
        
        if (txtView.text != "Enter Suggestions Here"){
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["Mydate@my.com”"])
        composeVC.setSubject("Suggestion")
        composeVC.setMessageBody(txtView.text, isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
        }
        else {
           Utilities.alertView(controller: self, title: "Suggestion", msg: "Please enter suggestion")
        }
    }
    
    @IBAction func mobileBtnPressED(_ sender: Any) {
        
        if (txtView.text != "Enter Suggestions Here"){
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = txtView.text
            controller.recipients = ["+61 0425258843"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
            
        }
        else {
            Utilities.alertView(controller: self, title: "Suggestion", msg: "Please enter suggestion")
        }
        
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
    //MARK: - TEXTVIEW METHODS
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Suggestions Here"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        if newText.characters.count == 0 {
            textView.textColor = UIColor.lightGray
        }else {
            textView.textColor = UIColor.black
        }
        
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 100;
       
    }
    
    
    func hide() {
        menuBtn.isEnabled = true
    }
    
    //MARK: - EMAIL METHOD
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
     
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - MOBILE METHOD
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

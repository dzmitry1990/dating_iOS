

import UIKit
import MessageUI

class SupportViewController: UIViewController,MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK:- IBACTIONS
    @IBAction func backPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    
    @IBAction func supportBtnPressed(_ sender: Any) {
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["Mydate@my.com"])
        composeVC.setSubject("Suggestion")
        composeVC.setMessageBody("", isHTML: false)
       
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    //MARK: - EMAIL METHOD
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}

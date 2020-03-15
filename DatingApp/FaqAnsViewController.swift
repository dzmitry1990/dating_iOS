
import UIKit

class FaqAnsViewController: UIViewController,hideMenu {
    
    @IBOutlet var questionLbl: UILabel!
    @IBOutlet var ansTextView: UITextView!
    @IBOutlet var menuBtn: UIButton!
    var faqDetail:faq?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLbl.text = faqDetail?.question
        ansTextView.text = faqDetail?.answer

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
    
    @IBAction func backPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    
}


import UIKit

class ConnectionViewController: UIViewController,hideMenu {
    
    @IBOutlet var menuBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
    
    @IBAction func messageBtnPressed(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func hide() {
        menuBtn.isEnabled = true
    }
    
    @IBAction func noThanksBtnPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    
}

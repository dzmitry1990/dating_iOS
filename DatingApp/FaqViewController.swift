
import UIKit

class FaqViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,hideMenu {
    
    
    
    @IBOutlet var tblView: UITableView!
    var faqArr:[faq] = []
    
    @IBOutlet var menuBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        callFaqApi()
    }
    
    //MARK: - IBACTIONS
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
    
    @IBAction func backPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    
    //MARK: - TABLEVIEW METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaqTableViewCell", for: indexPath) as? FaqTableViewCell
        cell?.selectionStyle = .none
        
        if (faqArr.count > 0){
            let valueFaq = faqArr[indexPath.row]
            cell?.nameLbl.text = valueFaq.question
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let valueFaq = faqArr[indexPath.row]
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FaqAnsViewController") as! FaqAnsViewController
        nextViewController.faqDetail = valueFaq
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    //MARK: FUNCTIONS
    func callFaqApi(){
        
        if (Reachability.isConnectedToNetwork()){
            Utilities.showProgressView(view: self.view)
            ApIManager.sharedInstance.getFaqQusAns(completion: { (values, success) in
                Utilities.hideProgressView(view: self.view)
                if (success){
                    if (values.count > 0){
                        self.faqArr = values
                        self.tblView.reloadData()
                    }
                    else {
                        Utilities.alertView(controller: self, title: "Not Found", msg: "Faq questions not found")
                    }
                }
                else {
                    Utilities.alertView(controller: self, title: "Try Again", msg: "Server Not Working")
                }
            })
            
        }
        else {
            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
        
        
    }
    func hide() {
        menuBtn.isEnabled = true
    }
    
    
    
}


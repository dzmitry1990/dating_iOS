
import UIKit
import SDWebImage

class AllMessagesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,hideMenu {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var menuBtn: UIButton!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var chatListsArr:[ChatLists] = []
    
    @IBOutlet var noTextFoundlbl: UILabel!
    var messageSubcription = false
    var userId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkSubscription()
        getChatUsers()
    }
    
    func getAllNotificationsApi(){
        
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        
        if (Reachability.isConnectedToNetwork()){
            Utilities.showProgressView(view: self.view)
            ApIManager.sharedInstance.getAllNotifications(auth_key: Authorization_key, completion: { (value,success) in
                Utilities.hideProgressView(view: self.view)
                if (success){
                    if (value.count > 0){
                        //self.notificationsArr = value
                        self.collectionView.reloadData()
                    }
                    else {
                        
                    }
                    print("successfully get notifications")
                }
                else {
                    print("no geting notifications")
                }
            })
            
        }
        else {
            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
        
    }
    
    
    func getChatUsers(){
        
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        
        if (Reachability.isConnectedToNetwork()){
            Utilities.showProgressView(view: self.view)
            ApIManager.sharedInstance.getChatLists(auth_key: Authorization_key, completion: { (values, success) in
            Utilities.hideProgressView(view: self.view)
                if (success){
                    if (values.count > 0){
                        self.noTextFoundlbl.text = ""
                        self.chatListsArr = values
                        self.collectionView.reloadData()
                    }
                    else {
                        self.noTextFoundlbl.text = "No Messages Found."
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
    
    
    //MARK:- CHECK SUSBSCRIPTION
    func checkSubscription(){
    
    if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
        let message = userInfo["messageSubscription"] as? String
        userId = (userInfo["id"] as? String)!
        let messageExpireDate = userInfo["messageSubscriptionExpireDate"] as? String
        
        if (message != "" && message != nil){
            
            let prvDateDoubleVal = Double(messageExpireDate!)
            let currentDate = NSDate()
            let Prevoiusdate =  NSDate(timeIntervalSince1970: prvDateDoubleVal!)
            
            switch Prevoiusdate.compare(currentDate as Date) {
            case .orderedAscending:
                self.messageSubcription = false
                break
            case .orderedSame:
                self.messageSubcription = true
                break
            case .orderedDescending:
                self.messageSubcription = true
                break
            }
        }
        else {
            self.messageSubcription = false
        }
        
    }
        
    }
    
    // MARK: - IBACTIONS
    @IBAction func returnBtnPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        if (appDelegate.notification == true){
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
            self.view.window?.rootViewController = secondViewController
            appDelegate.notification = false
        }
        else {
         Utilities.goBack(controller: self)
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
    
    func hide() {
        menuBtn.isEnabled = true
    }
    
    // MARK: - COLLECTIONVIEW METHODS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatListsArr.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "AllMessagesCollectionViewCell", for: indexPath) as! AllMessagesCollectionViewCell
        
        if (chatListsArr.count > 0){
            
            let value = chatListsArr[indexPath.row]
            cell.nameLbl.text = value.friend_name
            
            if (value.message_type == "1"){
                cell.photoView.isHidden = false
            }
            else {
                cell.photoView.isHidden = true
                cell.typeRequestSendLbl.text = value.message
            }
            
            cell.imgView.sd_setImage(with: URL(string:value.friend_photo), placeholderImage: UIImage(named: "user-Profile"))
            
            
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        let value = chatListsArr[indexPath.row]
            
        if (value.sender_id == userId){
           nextViewController.friendID = value.friend_id
        }
        else {
             nextViewController.friendID = value.sender_id
        }
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (Constants.screenSize == Constants.iphone5s){
            return CGSize(width: CGFloat((collectionView.frame.size.width / 2) - 5), height: CGFloat(106))
        }
        else {
            return CGSize(width: CGFloat((collectionView.frame.size.width / 2) - 5), height: CGFloat(118))
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "AllMessagesCollectionReusableView",
                                                                             for: indexPath) as! AllMessagesCollectionReusableView
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
        
        return UICollectionReusableView()
    }
    
    
    
}

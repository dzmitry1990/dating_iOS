import UIKit
import IQKeyboardManager

class MessageViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,hideMenu {
    
    @IBOutlet var chatTable: UITableView!
    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var mainView: UIView!
    var flag = false
    var chatHistoryArray : NSMutableArray = []
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var messageTextView: UITextView!
    @IBOutlet var tableViewButtom: NSLayoutConstraint!
    @IBOutlet var msgViewButtomCon: NSLayoutConstraint!
    var userID : String!
    var friendID : String!
    var messageType : String!
    var userPhoto = ""
    var friendPhoto = ""
    var chatArr:[Chats] = []
    
    @IBOutlet var showView: UIView!
    @IBOutlet var sendImgView: UIView!
    @IBOutlet var sendImg: UIImageView!
    @IBOutlet var sendImgBtn: UIButton!
    @IBOutlet var noTextFoundLbl: UILabel!
    var imagePicker = UIImagePickerController()
    
    @IBOutlet var showImgView: UIImageView!
    @IBOutlet var cameraBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (flag == true){
            menuBtn.isHidden = true
            flag = false
        }
        else {
            menuBtn.isHidden = false
        }
        
        //KEYBOARD METHODS
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if let authKey = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            self.userID = (authKey["id"] as? String)!
            self.userPhoto = (authKey["photo"] as? String)!
        }
        
        imagePicker.delegate = self
        
        //Chat Notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification), name: NSNotification.Name(rawValue: "ChatNotificationIdentifier"), object: nil)
        
        apiCallToGetChat()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        menuBtn.isEnabled = true
        //HIDE KEYBOARD
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        userID      = Utilities.getUserID() as! String
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    
    //MARK:- IBACTIONS
    @IBAction func backBtnPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    
    @IBAction func replyMessageBtnPressed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReplyMessagesViewController") as! ReplyMessagesViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        
        Utilities.goBack(controller: self)
        // menuBtn.isEnabled = false
        //  let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        //  menuVC.hideMenus = self
        //  self.view.addSubview(menuVC.view)
        //  self.addChildViewController(menuVC)
        //  menuVC.view.layoutIfNeeded()
        
        // menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        //  UIView.animate(withDuration: 0.3, animations: { () -> Void in
        //      menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        // }, completion:nil)
        
    }
    
    @IBAction func doubleHeartBtnPressed(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AllMessagesViewController") as! AllMessagesViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        
        let message = messageTextView.text
        if message == "Type a message..." || message == "" {
            Utilities.alertView(controller: self, title: "", msg: "Enter Message to send")
        }
        else {
            var chatInfo:[String:Any] = [:]
            chatInfo["friend_id"] = friendID
            chatInfo["message"] = messageTextView.text
            chatInfo["message_type"] = "0"
            apiSendMessageApi(chatInfo: chatInfo)
        }
        
    }
    
    @IBAction func sendImgBtnPressed(_ sender: Any) {
        var chatInfo:[String:Any] = [:]
        chatInfo["friend_id"] = friendID
        chatInfo["message_type"] = "1"
        self.sendImgView.isHidden = true
        apiSendPhotoApi(chatInfo: chatInfo,photo: self.sendImg.image!)
    }
    
    @IBAction func crossBtnPressed(_ sender: Any) {
        self.sendImgView.isHidden = true
    }
    @IBAction func showCancelBtnPressed(_ sender: Any) {
        self.showView.isHidden = true
        
    }
    
    @IBAction func cameraBtnPressed(_ sender: Any) {
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        pickerView.sourceType = .photoLibrary
        // self.presentViewController(pickerView, animated: true, completion: nil)
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Photo Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        // photoPicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - FUNCTIONS
    func hide(){
        menuBtn.isEnabled = true
    }
    
    func scrollToLastRow() {
        if chatArr.count > 0 {
            let indexPath = IndexPath(row: chatArr.count - 1, section: 0)
            chatTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func messageSent(){
        self.messageTextView.text = "Type a message..."
        self.view.endEditing(true)
        self.performSelector(inBackground: #selector(self.apiCallToGetChat), with: nil)
    }
    
    func getTime(str:String) -> String{
        let dateDD  = Double(str)
        let date = NSDate(timeIntervalSince1970:dateDD!)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd, YYYY hh:mm a"
        let dateTime =  dayTimePeriodFormatter.string(from: date as Date)
        return dateTime
    }
    
    func methodOfReceivedNotification(notification: Notification){
        
        let userInfo = notification.object as? [AnyHashable: Any]
        let dataVal = userInfo!["body"] as? [String:Any]
        let value =  Chats.ChatsDetailSaved(data: dataVal!)
        chatArr.append(value)
        self.chatTable.reloadData()
        self.scrollToLastRow()
       /// let notificationData = dataVal!["Notification"] as? [String:Any]
        //print(notificationData)
        //let value = PrivateChat.PrivateChatDetailSaved(data: notificationData!)
       // self.privateChatList.append(value)
        //tblView.reloadData()
        //self.scrollToLastRow()
        // self.performSelector(inBackground: #selector(self.apiCallToGetChat), with: nil)
    }
    
    //MARK: - IMAGEPICKER METHODS
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        print(image)
        self.sendImgView.isHidden = false
        self.sendImgView.backgroundColor = UIColor.lightGray
        self.sendImgBtn.isHidden = false
        self.sendImg.image = image
        dismiss(animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"Cancel")
            alertWarning.show()
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: UITABLEVIEW METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = self.chatArr[indexPath.row]
        let userId = dict.is_send
        let messageType = dict.message_type
        
        if (userId != "1")
        {
            if (messageType == "0"){
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderMsgChatTableViewCell", for: indexPath) as? SenderMsgChatTableViewCell
                cell?.selectionStyle = .none
                cell?.imgView?.sd_setImage(with: URL(string:friendPhoto), placeholderImage: UIImage(named: "user-Profile"))
                cell?.msgLbl.text = dict.message
                cell?.dateLbl.text = getTime(str: dict.created)
                return cell!
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderImageChatTableViewCell", for: indexPath) as? SenderImageChatTableViewCell
                cell?.selectionStyle = .none
                cell?.imgView?.sd_setImage(with: URL(string:friendPhoto), placeholderImage: UIImage(named: "user-Profile"))
                cell?.msgImgView?.sd_setImage(with: URL(string:dict.message), placeholderImage: UIImage(named: "user-Profile"))
                cell?.datelbl.text = getTime(str: dict.created)
                return cell!
            }
        }
        else {
            if (messageType == "0"){
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyMsgChatTableViewCell", for: indexPath) as? MyMsgChatTableViewCell
                cell?.selectionStyle = .none
                cell?.imgView?.sd_setImage(with: URL(string:userPhoto), placeholderImage: UIImage(named: "placeholderImg"))
                cell?.msgLbl.text = dict.message
                cell?.dateLbl.text = getTime(str: dict.created)
                return cell!
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyImageChatTableViewCell", for: indexPath) as? MyImageChatTableViewCell
                cell?.selectionStyle = .none
                cell?.imgView?.sd_setImage(with: URL(string:userPhoto), placeholderImage: UIImage(named: "user-Profile"))
                cell?.msgImgView?.sd_setImage(with: URL(string:dict.message), placeholderImage: UIImage(named: "placeholderImg"))
                cell?.datelbl.text = getTime(str: dict.created)
                return cell!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = self.chatArr[indexPath.row]
        let messageType = dict.message_type
        
        if (messageType == "1"){
             self.showView.isHidden = false
             self.showImgView.sd_setImage(with: URL(string:dict.message), placeholderImage: UIImage(named: "placeholderImg"))
        }
    }
    
    
    
    //MARK: - TEXTFIELD METHODS
    func textFieldDidBeginEditing(_ textField: UITextField){
        print("begin editing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: textViewDelegates&Datasources
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type a message..." {
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Type a message..."
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textVal: NSString = (textView.text ?? "") as NSString
        let resultString = textVal.replacingCharacters(in: range, with: text)
            if resultString.characters.count == 0 {
                cameraBtn.isHidden = false
            }else {
                cameraBtn.isHidden = true
            }
        return true
    }
    
    //MARK:- KEYBOARD METHODS
    func keyboardWillShow(notification: NSNotification) {
        
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        self.msgViewButtomCon.constant = keyboardSize.height + 0
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        self.msgViewButtomCon.constant = 0
        
    }
    
    
    //MARK: - API CALL'S
    func apiCallToGetChat() {
        
        var chatInfo:[String:Any] = [:]
        chatInfo["friend_id"] = friendID
        
        if (Reachability.isConnectedToNetwork()){
            ApIManager.sharedInstance.getAllChats(userInfo: chatInfo, completion: { (values,friendPhoto,error,success) in
                if (success){
                    if (error == ""){
                        self.chatArr = values
                        self.friendPhoto = friendPhoto
                        if (values.count > 0){
                            self.chatTable.reloadData()
                            self.scrollToLastRow()
                        }
                        else {
                            //self.noTextFoundLbl.text = "No chat's found."
                            //Utilities.alertView(controller: self, title: "", msg: "No chat's found.")
                        }
                    }
                    else {
                        Utilities.alertView(controller: self, title: "", msg: error)
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
    
    func apiSendMessageApi(chatInfo:[String:Any]){
        
        if (Reachability.isConnectedToNetwork()){
            
            ApIManager.sharedInstance.sendChatMessages(chatInfo: chatInfo, completion: { (error, success) in
                if (success){
                    self.messageSent()
                    self.cameraBtn.isHidden = false
                }
                else {
                    print("not suucess")
                }
            })
            
        }
        else {
            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
    }
    
    func apiSendPhotoApi(chatInfo:[String:Any],photo:UIImage){
        
        if (Reachability.isConnectedToNetwork()){
            
            ApIManager.sharedInstance.sendChatImageApi(chatInfo: chatInfo, image: photo, completion: { (success) in
                if (success){
                    self.messageSent()
                    self.scrollToLastRow()
                }
                else {
                    print("not suucess")
                }
            })
            
        }
        else {
             Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
        
    }
    
}

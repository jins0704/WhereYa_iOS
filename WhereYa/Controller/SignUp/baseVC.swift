//
//  CommonViewController.swift
//  GOGO
//
//  Created by 홍진석 on 2021/02/17.
//

import UIKit

class baseVC: UIViewController{
    
    var focusedTextField : UITextField?
    var isChangedTextField : Bool = false
    var beforefocusedTextField : CGFloat = CGFloat.init(300)
    
    var touchRecognizer : UIGestureRecognizer = UIGestureRecognizer(target: self, action: nil)
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(ActivityIndicator.shared.activityIndicator)
        
        self.focusedTextField?.delegate = self
        self.touchRecognizer.delegate = self
        
        navigationController?.navigationBar.isHidden = true
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        // Notification 생성 - Keyboard register
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHideHandle), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
     
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Notification 해제 - keyboard unregister
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Notification Selector
    
    @objc func keyboardShowHandle(notification : NSNotification){
        guard let fView = focusedTextField else{return}
        //키보드 사이즈 가져오기
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil{

            if fView.frame.origin.y > 470 && isChangedTextField == true && fView.frame.origin.y > beforefocusedTextField{
                
                let changeMount = fView.frame.origin.y - beforefocusedTextField
                print("dd")
                UIView.animate(withDuration: 0.3, animations: {
                                self.view.frame.origin.y -= (changeMount/5)})

                self.isChangedTextField = false
                self.beforefocusedTextField = fView.frame.origin.y
            }
        }
    }
    
    @objc func keyboardHideHandle(){
        //뷰 원상태로 되돌리기
        self.view.frame.origin.y = 0
        self.beforefocusedTextField = 0
        self.isChangedTextField = false
    }
    
    // MARK: - ButtonState()
    // 다음 단계로 넘어가도 되는지 체크
    func ButtonState(_ nextChecks : Array<Bool>, _ nextBtn : UIButton){
        
        var notCompleted : Bool = false
        
        for check in nextChecks{
            if check == false{
                notCompleted = true
            }
        }
        print(nextChecks)
        
        if notCompleted{
            nextBtn.backgroundColor = UIColor.lightGray
            nextBtn.isEnabled = false
        }
        else{
            self.view.endEditing(true)
            nextBtn.backgroundColor = UIColor.mainBlueColor
            nextBtn.isEnabled = true
        }
    }
    
    func textFieldLayer(_ view: UITextField){
        view.borderStyle = .roundedRect
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        view.setLeftPaddingPoints(15)
        view.setRightPaddingPoints(15)
        view.autocorrectionType = .no
        view.spellCheckingType = .no
        view.returnKeyType = .done
    }
    
}
extension baseVC : UIGestureRecognizerDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
}

// MARK: - TextFieldDelegate

extension baseVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        focusedTextField = textField
        self.isChangedTextField = true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let inputTextCount = textField.text?.appending(string).count ?? 0
        
        //12자 이하로만 입력받기
        return inputTextCount <= 12
    }
}

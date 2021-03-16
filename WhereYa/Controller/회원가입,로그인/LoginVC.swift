//
//  LoginViewController.swift
//  GOGO
//
//  Created by 홍진석 on 2021/02/01.
//

import UIKit

class LoginVC: baseVC{

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var findInfoBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
    
        textFieldLayer(idTextField)
        textFieldLayer(passwordTextField)
        
        loginBtn.layer.cornerRadius = 10
        
        signinBtn.setTitleColor(.black, for: .normal)
        findInfoBtn.setTitleColor(.black, for: .normal)
        
        idTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        ActivityIndicator.shared.activityIndicator.startAnimating()
        
        guard let id = idTextField.text,
              let pwd = passwordTextField.text else{return}
        
        LoginService.shared.login(id, pwd) { data in
          
            ActivityIndicator.shared.activityIndicator.stopAnimating()
            
            switch data{
            case .success(let token) :
                guard let token = token as? String else { return }
                print("success")
                
                UserDefaults.standard.setValue(token, forKey: "token")
            
                let storyboard = UIStoryboard.init(name: "TabbarVC", bundle: nil)
                let basetabbarVC = storyboard.instantiateViewController(identifier:"BaseTabbarVC")  as! BaseTabbarVC

                basetabbarVC.modalPresentationStyle = .fullScreen
                self.present(basetabbarVC, animated: true, completion: nil)
                
            case .requestErr(let message):
                print(message)
                return
            case .serverErr:
                print("serverErr")
                return
                
            case .networkFail:
                print("networkFail")
                return
            }
        }
    }
}


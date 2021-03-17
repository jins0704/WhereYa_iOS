//
//  LoginViewController.swift
//  GOGO
//
//  Created by 홍진석 on 2021/02/01.
//

import UIKit
import Lottie

class LoginVC: baseVC{

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var findInfoBtn: UIButton!
    
    let animationView : AnimationView = {
        let aniView = AnimationView(name: "16315-map")
    
        aniView.contentMode = .scaleAspectFill
        return aniView
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UISetting()
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
                UserDefaults.standard.setValue(self.idTextField.text, forKey: "user_id")
                
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
    
    func UISetting(){
        
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor).isActive = true
        animationView.center = view.center
        
        self.navigationController?.navigationBar.isHidden = true
    
        textFieldLayer(idTextField)
        textFieldLayer(passwordTextField)
        
        loginBtn.layer.cornerRadius = 10
        
        signinBtn.setTitleColor(.black, for: .normal)
        findInfoBtn.setTitleColor(.black, for: .normal)
        
        idTextField.delegate = self
        passwordTextField.delegate = self
        
        idTextField.text = ""
        passwordTextField.text = ""
        
        animationView.play{(finish) in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.6){
                self.animationView.removeFromSuperview()
                self.mainImageView.image = #imageLiteral(resourceName: "스크린샷 2021-03-18 오전 3.06.02-1")
            }
        }
    }
}


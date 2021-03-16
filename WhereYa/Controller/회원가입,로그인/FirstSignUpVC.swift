//
//  FirstSignInViewController.swift
//  GOGO
//
//  Created by 홍진석 on 2021/02/17.
//

import UIKit
import Toast_Swift

class FirstSignUpVC: baseVC{
    
    @IBOutlet weak var id_SignInTextField: UITextField!
    @IBOutlet weak var pwd_SignInTextField: UITextField!
    @IBOutlet weak var repwd_SignInTextField: UITextField!
    @IBOutlet weak var nickname_SignInTextField: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    //고정 검정 라벨들
    @IBOutlet weak var SignInLabel: UILabel!
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var PwdLabel: UILabel!
    @IBOutlet weak var REpwdLabel: UILabel!
    @IBOutlet weak var idCheckBtn: UIButton!
    
    @IBOutlet weak var idCheckMark: UIImageView!

    @IBOutlet weak var pwdCheckMark: UIImageView!
    
    var idCheck : Bool! //아이디 중복확인
    var pwdCheck : Bool! //비밀번호 확인
    var nickCheck : Bool! //닉네임 중복확인
    
    //텍스트 필드 모음
    var textFields : Array<UITextField>?
    
    //다음 넘어갈 조건들 모음
    var nextChecks = [false,false] //아이디 중복, 비밀번호 동일,
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetting()
        
        textFields = [id_SignInTextField,
                      pwd_SignInTextField,
                      repwd_SignInTextField]

        nextBtn.isEnabled = false
        
        print(nextChecks)
    }
    
    // MARK: - IBAction
    @IBAction func backBtnPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "signin", sender: nil)
    }
    
    @IBAction func idCheckClicked(_ sender: UIButton) {
        checkDuplicatedData(dataType : "id", id_SignInTextField)
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let next : SecondSignUpVC = segue.destination as? SecondSignUpVC else{return}
     
        next.id = id_SignInTextField.text
        next.pwd = pwd_SignInTextField.text

    }
    
    // MARK: - TextFieldDelegate
    override func textFieldDidChangeSelection(_ textField: UITextField) {
        if let pwdText = pwd_SignInTextField.text, let repwdText = repwd_SignInTextField.text{
            if pwdText == repwdText && pwdText.count > 0 {
                self.nextChecks[1] = true
                self.pwdCheckMark.isHidden = true
                //print("비밀번호 일치")
            }
            else{
                self.nextChecks[1] = false
                
                if repwdText.count <= 0 || pwdText.count <= 0 {
                    self.pwdCheckMark.isHidden = true
                }
                else{
                    self.pwdCheckMark.isHidden = false
                    //print("비밀번호 불일치")
                }
            }
        }
        
        if textField == id_SignInTextField{
            DispatchQueue.main.async{
                self.idCheckMark.isHidden = true
            }
            nextChecks[0] = false
        }
        
        ButtonState(nextChecks, nextBtn)
    }
    
    // MARK: - UISetting
    func UISetting(){
        textFieldLayer(id_SignInTextField)
        textFieldLayer(pwd_SignInTextField)
        textFieldLayer(repwd_SignInTextField)
        
        idCheckBtn.layer.cornerRadius = 5
        
        SignInLabel.textColor = UIColor.black
        IDLabel.textColor = UIColor.black
        PwdLabel.textColor = UIColor.black
        REpwdLabel.textColor = UIColor.black
        
        id_SignInTextField.delegate = self
        pwd_SignInTextField.delegate = self
        repwd_SignInTextField.delegate = self
        
        idCheckMark.isHidden = true
        pwdCheckMark.isHidden = true
        
        idCheckMark.tintColor = UIColor.blue
        pwdCheckMark.tintColor = UIColor.systemPink
        
        nextBtn.backgroundColor = UIColor.lightGray
    }
    
    // MARK: - ButtonState
    override func ButtonState(_ nextChecks: Array<Bool>, _ nextBtn: UIButton) {
        super.ButtonState(nextChecks, nextBtn)
    }
    
    // MARK: - checkDuplicatedData()
    // 아이디 중복확인
    func checkDuplicatedData(dataType : String, _ textfield : UITextField){
        
        ActivityIndicator.shared.activityIndicator.startAnimating()
        
        if let userInput = textfield.text {
            if userInput.count > 0{
                
                SignUpService.shared.checkData(userInput, dataType) { (result) in
                    
                    ActivityIndicator.shared.activityIndicator.stopAnimating()
                    
                    switch result{
                    
                    case .success(let message) :
                        if message as! String == "아이디"{
                            DispatchQueue.main.async{
                                self.idCheckMark.isHidden = false
                            }
                            self.nextChecks[0] = true
                        }
                        
                        DispatchQueue.main.async{
                            self.ButtonState(self.nextChecks,self.nextBtn)
                        }
                       
                        
                    case .requestErr(let message) :
                        print(userInput)
                        print(dataType)
                        self.view.makeToast("이미 존재하는 \(message)입니다.", duration: 0.5, position: .center)
                        
                    //사용가능 데이터
                    case .serverErr:
                        print(".serverErr")
                        return
                    case .networkFail:
                        print("network_error")
                        return
                    }
                }
            }
            else{
                self.view.makeToast("입력이 필요합니다.", duration: 0.5, position: .center)
                ActivityIndicator.shared.activityIndicator.stopAnimating()
            }
        }
        
        self.view.endEditing(true)
    }
}

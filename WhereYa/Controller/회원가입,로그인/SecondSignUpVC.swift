//
//  SecondSignInViewController.swift
//  GOGO
//
//  Created by 홍진석 on 2021/02/17.
//

import UIKit

class SecondSignUpVC: baseVC, PopUpDelegate {
 
    @IBOutlet weak var popupBtn: UIButton!
    
    @IBOutlet weak var genderStackView: UIStackView!
    @IBOutlet weak var nickCheckMark: UIImageView!
    @IBOutlet weak var nickCheckBtn: UIButton!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    
    @IBOutlet weak var gender_ManBtn: UIButton!
    @IBOutlet weak var gender_WomanBtn: UIButton!
    @IBOutlet weak var completeBtn: UIButton!
    
    //검정 고정 라벨들
    @IBOutlet weak var SignInLabel: UILabel!
    @IBOutlet weak var NickLabel: UILabel!
    @IBOutlet weak var GenderLabel: UILabel!
    @IBOutlet weak var BirthLabel: UILabel!
    
    var id : String?
    var pwd : String?
    var nickname : String?
    var gender : String?
    var birthday : String?
    
    var nextChecks = [false,false,false] //닉네임,성별선택,생년월일
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetting()
        ButtonState(nextChecks, completeBtn)
        
        nicknameTextField.delegate = self
        birthTextField.delegate = self

    }
    @IBAction func nickCheckBtnClicked(_ sender: Any) {
        checkDuplicatedData(dataType : "nickname", nicknameTextField)
    }
    
    @IBAction func popupBtnClicked(_ sender: Any) {
        //팝업 스토리보드 가져오기
        let storyboard = UIStoryboard.init(name: "DatePopUp", bundle: nil)
        //스토리보드 통해 팝업 컨트롤러 가져오기
        let popUpVC = storyboard.instantiateViewController(identifier: "PopUpVC") as! DataPopUpVC
        //팝업 효과 스타일 설정
        popUpVC.modalPresentationStyle = .overCurrentContext //덮어 보여주는 스타일
        popUpVC.modalTransitionStyle = .crossDissolve //스르르 사라지는 스타일
                
        popUpVC.popupDelegate = self
        self.present(popUpVC, animated: true, completion: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func manBtnClicked(_ sender: Any) {
        gender_ManBtn.backgroundColor = UIColor.mainBlueColor
        gender_ManBtn.titleLabel?.tintColor = UIColor.white
        
        gender_WomanBtn.backgroundColor = UIColor.white
        gender_WomanBtn.titleLabel?.tintColor = UIColor.black
    
        nextChecks[1] = true
        gender = "MALE"
    }
    
    @IBAction func womanBtnClicked(_ sender: Any) {
        gender_WomanBtn.backgroundColor = UIColor.subpink
        gender_WomanBtn.titleLabel?.tintColor = UIColor.white
        
        gender_ManBtn.backgroundColor = UIColor.white
        gender_ManBtn.titleLabel?.tintColor = UIColor.black
        
        nextChecks[1] = true
        gender = "FEMALE"
    }
    
    @IBAction func completeBtnClicked(_ sender: Any) {
        
        ActivityIndicator.shared.activityIndicator.startAnimating()
        
        //userID password nickname name gender birthday phoneNumber 준다
         
        let user = User(id!, pwd!, nickname!, gender!, birthday!)
        
        SignUpService.shared.signUp(user) { (result) in
            
            ActivityIndicator.shared.activityIndicator.stopAnimating()
            
            switch result{
            case .success(_) :
                print("second 성공")
                
                guard let loginView = self.storyboard?.instantiateViewController(withIdentifier: "loginView") as? LoginVC else {return}

                loginView.modalPresentationStyle = .fullScreen

                let alert = UIAlertController(title: "회원가입 성공!", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default, handler: {
                    (alert : UIAlertAction!) -> Void in
                    self.present(loginView, animated: true, completion: nil)
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            case .requestErr(_) :
                print("second 실패")
                
            case .serverErr:
                print(".serverErr")
                return
                
            case .networkFail:
                print("network_error")
                return
            }
        }
    }
    // MARK: - ButtonState
    override func ButtonState(_ nextChecks: Array<Bool>, _ nextBtn: UIButton) {
        super.ButtonState(nextChecks, completeBtn)
    }
    
    // MARK: - UISetting
    func UISetting(){
        textFieldLayer(nicknameTextField)
        textFieldLayer(birthTextField)
        
        nickCheckBtn.layer.cornerRadius = 5
        nickCheckMark.isHidden = true
        
        
        gender_ManBtn.layer.borderWidth = 0.3
        gender_ManBtn.layer.borderColor = UIColor.lightGray.cgColor
        gender_ManBtn.layer.cornerRadius = 5
        
        gender_WomanBtn.layer.borderWidth = 0.3
        gender_WomanBtn.layer.borderColor = UIColor.lightGray.cgColor
        gender_WomanBtn.layer.cornerRadius = 5
        
        gender_ManBtn.titleLabel?.tintColor = UIColor.black
        gender_WomanBtn.titleLabel?.tintColor = UIColor.black
        
        SignInLabel.textColor = UIColor.black
        NickLabel.textColor = UIColor.black
        GenderLabel.textColor = UIColor.black
        BirthLabel.textColor = UIColor.black
    }
    
    // MARK: - popupDelegate
    func doneBtnClicked(data : String) {
        
        self.birthTextField.text = data
        birthday = data
        
        nextChecks[2] = true
        ButtonState(nextChecks, completeBtn)
        
    }
    
    // MARK: - TextFieldDelegate
    override func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField == nicknameTextField{
            
            nickname = nicknameTextField.text
            
            DispatchQueue.main.async{
                self.nickCheckMark.isHidden = true
            }
            nextChecks[0] = false
        }
        
        ButtonState(nextChecks, completeBtn)
    }
   
    // MARK: - checkDuplicatedData()
    // 닉네임 중복확인
    func checkDuplicatedData(dataType : String, _ textfield : UITextField){
        
        ActivityIndicator.shared.activityIndicator.startAnimating()
        
        if let userInput = textfield.text {
            if userInput.count > 0{
                
                SignUpService.shared.checkData(userInput, dataType) { (result) in
                    
                    ActivityIndicator.shared.activityIndicator.stopAnimating()
                    
                    switch result{
                    
                    case .success(let message) :
                        if message as! String == "닉네임"{
                            DispatchQueue.main.async{
                                self.nickCheckMark.isHidden = false
                            }
                            self.nextChecks[0] = true
                        }
                        
                        DispatchQueue.main.async{
                            self.ButtonState(self.nextChecks,self.completeBtn)
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

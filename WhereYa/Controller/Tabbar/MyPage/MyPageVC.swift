//
//  MyPageVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/17.
//

import UIKit

class MyPageVC: UIViewController {
    
    let user = UserDefaults.standard
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var profileNicknameLabel: UILabel!
    @IBOutlet weak var profileIdLabel: UILabel!
    
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        self.profileNicknameLabel.text = user.string(forKey: UserKey.NICKNAME)
        self.profileIdLabel.text = user.string(forKey: UserKey.ID)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ProfileService.shared.getImage { (data) in
            ActivityIndicator.shared.activityIndicator.stopAnimating()
            
            switch data{
            case .success(let imgurl) :
                guard let imgurl = imgurl as? String else { return }
                print("success")
                if let url = URL(string: imgurl){
                    do{
                        let urldata = try Data(contentsOf: url)
                        self.profileImage.image = UIImage(data: urldata)
                        UserDefaults.standard.setValue(imgurl, forKey: UserKey.IMAGE)
                    }catch{
                        print("data error")
                        print(error)
                    }
                }
                
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
    
    
    @IBAction func profileImageBtnClicked(_ sender: Any) {
        let alert =  UIAlertController(title: "", message: "프로필 사진 설정", preferredStyle: .actionSheet)
      
        let library =  UIAlertAction(title: "앨범", style: .default) {
            (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: false, completion: nil)
        }

        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: false, completion: nil)
        }

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)

    }
    
    func setUI(){
        
        self.titleLabel.font = UIFont.myBoldSystemFont(ofSize: 25)
        profileIdLabel.font = UIFont.myRegularSystemFont(ofSize: 17)
        profileNicknameLabel.font = UIFont.myRegularSystemFont(ofSize: 17)
        
        self.mainView.layer.cornerRadius = 5
        self.mainView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.layer.borderWidth = 1
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor.clear.cgColor
        
        profileImageBtn.layer.cornerRadius = profileImageBtn.frame.height/2
        profileImageBtn.layer.borderWidth = 0.4
        profileImageBtn.clipsToBounds = true
        profileImageBtn.layer.borderColor = UIColor.black.cgColor
        
    }
}

extension MyPageVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let myimage = info[.editedImage] as? UIImage,
           let myurl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            ProfileService.shared.updateImage(img: myimage, url : myurl, completion: { (data) in
                
                ActivityIndicator.shared.activityIndicator.stopAnimating()

                switch data{
                case .success(let imgurl) :
                    guard let imgurl = imgurl as? String else { return }
                    UserDefaults.standard.setValue(imgurl, forKey: UserKey.IMAGE)
                   
                    self.profileImage.image = myimage
             
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
                
            })
            
            picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
        }
    }
}

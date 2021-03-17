//
//  MyPageVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/17.
//

import UIKit

class MyPageVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var profileNicknameLabel: UILabel!
    @IBOutlet weak var profileIdLabel: UILabel!
    
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetting()
        
        let user = UserDefaults.standard
      
        self.profileNicknameLabel.text = user.string(forKey: "user_nickname")
        self.profileIdLabel.text = user.string(forKey: "user_id")
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func profileImageBtnClicked(_ sender: Any) {
        let alert =  UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)
      
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
    
    func UISetting(){
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
        
        var newImage: UIImage? = nil // update image
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우
            
        }
        else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        self.profileImage.image = newImage // 받아온 이미지를 update
        
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
        
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("error :  \(info)")
        }
        
        let imageUrl=info[UIImagePickerController.InfoKey.imageURL] as? NSURL //이미지 url
        let imageName = imageUrl?.lastPathComponent//이미지 이름
        
        ProfileUpdateService.shared.update(nickname: profileIdLabel.text ?? "asd", img: selectedImage, imgName: imageName ?? "asd") {data in
            print(data)
        }
        
    }
}

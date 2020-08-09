//
//  EditUserinfoViewController.swift
//  Instasample
//
//  Created by 樋口裕貴 on 2020/04/27.
//  Copyright © 2020 Yuki Higuchi. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit
class EditUserinfoViewController: UIViewController , UITextFieldDelegate,UITextViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet var userImargeView : UIImageView!
    @IBOutlet var userNameTextField : UITextField!
    @IBOutlet var userIdTextField : UITextField!
    @IBOutlet var introductionTextView : UITextView!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        userIdTextField.delegate = self
        introductionTextView.delegate = self
        
//        let user = NCMBUser.current()
//               userNameTextField.text = user?.object(forKey: "userName") as! String
//               introductionTextView.text = user?.object(forKey: "introduction") as! String
//        userIdTextField.text = user?.userName
               
        
        let userId = NCMBUser.current()?.userName
        userIdTextField.text = userId
        
         let file = NCMBFile.file(withName: NCMBUser.current().objectId, data: nil) as! NCMBFile
               file.getDataInBackground { (data, error) in
                   if error != nil{
                       print(error)
                   }else{
                       let image = UIImage(data: data!)
                       self.userImargeView.image = image
                   }
               }
           
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
   
        //写真の容量をリサイズ
        let resizedImage = selectedImage.scale(byFactor: 0.3)
        
        
        picker.dismiss(animated: true, completion: nil)
        
        let data = resizedImage?.pngData()!
        let file = NCMBFile.file(withName: NCMBUser.current()?.objectId, data: data) as! NCMBFile
        file.saveInBackground({ (error) in
            if error != nil{
                print(error)
            }else{
                self.userImargeView.image = selectedImage            }
        }) { (progress) in
            print(progress)
        }
    }
    
    
    
    
    
    @IBAction func selsctImage () {
//        アラート
        let actionController = UIAlertController(title: "画像の選択", message: "画像を選択してください", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
            //カメラ起動のコード
            if UIImagePickerController.isSourceTypeAvailable(.camera){
            let picker = UIImagePickerController()
            //カメラからソースをひっぱてくる
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
            }else{
                print("この端末では使用できません")
            }
        }
        let albumAction = UIAlertAction(title: "フォトライブラリ", style: .default) { (action) in
            //アルバムの起動
             let picker = UIImagePickerController()
                       //フォトライブラリからソースをひっぱてくる
            picker.sourceType = .photoLibrary
                       picker.delegate = self
                       self.present(picker, animated: true, completion: nil)
            
        }
//    キャンセルコード
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
            actionController.dismiss(animated: true, completion: nil)
        }
        
//       使うアクションの選択
        actionController.addAction(cameraAction)
        actionController.addAction(albumAction)
        actionController.addAction(cancelAction)
        //アクションを表示させるコード
        self.present(actionController,animated: true,completion: nil)
        
    }
    
    
    
    @IBAction func closeEditViewController () {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveUserInfo () {
        let user = NCMBUser.current()
        user?.setObject(userNameTextField.text, forKey: "displayName")
        user?.setObject(userIdTextField.text, forKey: "userName")
        user?.setObject(introductionTextView.text, forKey: "introduction")
        user?.saveInBackground({ (error) in
            if error != nil{
                print(error)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        })
    }

  

}

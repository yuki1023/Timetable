//
//  SigninViewController.swift
//  Instasample
//
//  Created by 樋口裕貴 on 2020/04/23.
//  Copyright © 2020 Yuki Higuchi. All rights reserved.
//

import UIKit
import NCMB

class SigninViewController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet var userIdTextField : UITextField!
    @IBOutlet var passTextField : UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signIn (){
        if userIdTextField.text != nil && passTextField.text != nil {
             NCMBUser.logInWithUsername(inBackground: userIdTextField.text!, password: passTextField.text!) { (user, error) in
                if error != nil{
                    print(error)
                }else{
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    //ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "isLogin")
                    ud.synchronize()
                }
                   }
                   
        }
        
        
    }
    @IBAction func forgetpass (){
        
    }
    
    
}

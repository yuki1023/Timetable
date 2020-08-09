//
//  AddSubjectViewController.swift
//  Instasample
//
//  Created by 樋口裕貴 on 2020/05/29.
//  Copyright © 2020 Yuki Higuchi. All rights reserved.
//

import UIKit
import NCMB

class AddSubjectViewController: UIViewController , UITableViewDataSource,UITableViewDelegate{
    
    
    var subjectArray = [NCMBObject]()
    
    var passedIndexData : Int!
    
    var selectedSubject : NCMBObject!
    
    
    @IBOutlet var subjectListTabelView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        subjectListTabelView.delegate = self
        subjectListTabelView.dataSource = self

        loadSubjectList()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return subjectArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = subjectArray[indexPath.row].object(forKey: "className") as! String
        
        return cell!
        
    }



    func loadSubjectList(){
        let query = NCMBQuery(className: "Class")
                query?.whereKey("time", equalTo: passedIndexData)
                query?.findObjectsInBackground({ (result, error) in
                    if error != nil{
                        print(error)
                    }else{
                        print(result)
                        var subject = result as! [NCMBObject]
                        for i in subject {
                            let subjectName = i.object(forKey: "className")
                            self.subjectArray.append(i)
                            self.subjectListTabelView.reloadData()
                            
                        }

                    }

                
                
            })
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        selectedSubject = subjectArray[indexPath.row]
   
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: subjectArray[indexPath.row].object(forKey: "className") as! String, message: "登録してもよろしいですか？", preferredStyle:  UIAlertController.Style.alert)

        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            self.update()
            self.dismiss(animated: true, completion: nil)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })

        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)

        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func update(){
        let object = NCMBObject(className: "RegisterInfo")
        object?.setObject(NCMBUser.current()?.object(forKey: "objectId"), forKey: "student")
        object?.setObject(selectedSubject.object(forKey: "objectId"), forKey: "subjectId")
        object?.saveInBackground({ (error) in
            if error != nil{
                //もしエラーが発生したら
             print("error")
            }else{
                self.dismiss(animated: true, completion: nil)
                //保存に成功した場合
//                print("success")
              
            }
        })
        
        
        
    }
    
}
    


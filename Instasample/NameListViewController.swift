//
//  NameListViewController.swift
//  Instasample
//
//  Created by 樋口裕貴 on 2020/05/22.
//  Copyright © 2020 Yuki Higuchi. All rights reserved.
//

import UIKit
import NCMB

class NameListViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    var nameArray = [NCMBUser]()
    var passedClassData : NCMBObject!
    
    var nameSelectedIndex : IndexPath!
    
    @IBOutlet var nameListTableView : UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameListTableView.delegate = self
        nameListTableView.dataSource = self

        loadList()
        print(passedClassData)
        print(NCMBUser.current())
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(nameArray)
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = nameArray[indexPath.row].object(forKey: "userName") as! String
        
        return cell!
    }

    
    func loadList(){
        let query = NCMBQuery(className: "RegisterInfo")
        query?.whereKey("subjectId", equalTo: passedClassData.object(forKey: "objectId"))
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                print(error)
            }else{
                print(result)
                var student = result as! [NCMBObject]
                for i in student {
                    print(student)
                    let studentId = i.object(forKey: "student")
                    let userQuery = NCMBUser.query()
                    print(studentId)
                    print(userQuery)
                    userQuery?.whereKey("objectId", equalTo: studentId)
                    userQuery?.findObjectsInBackground({ (result, error) in
                        if error != nil {
                            print(error)
                        }else{
                            print(result)
                            var userData = result as! [NCMBUser]
                            for user in userData{
                                
                                self.nameArray.append(user)
                                self.nameListTableView.reloadData()
                            }
                            
                             
                        }
                    })
                    
                }
                
            }
        
        
        
    })
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nameSelectedIndex = indexPath
        self.performSegue(withIdentifier: "toFriend", sender: nil)
        
        
       
    }
    //値渡しの関数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFriend"{
            //次の画面の取得
            let FriendPageViewController = segue.destination as! FriendPageViewController
            
            
            FriendPageViewController.passedFriendData = nameArray[nameSelectedIndex.row]
            print(nameArray[nameSelectedIndex.row])
        }
    }
    
    
    
}

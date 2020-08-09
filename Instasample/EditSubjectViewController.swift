//
//  EditSubjectViewController.swift
//  Instasample
//
//  Created by 樋口裕貴 on 2020/06/11.
//  Copyright © 2020 Yuki Higuchi. All rights reserved.
//

import UIKit
import NCMB

class EditSubjectViewController: UIViewController {

    @IBOutlet var subjectLabel : UILabel!
    @IBOutlet var teacherNameLabel : UILabel!
    
    var passedData : NCMBObject!
    

    
    
    
    override func viewWillAppear(_ animated: Bool) {
      
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        print(passedData)
    }

    func loadData(){
        let subjectName = passedData.object(forKey: "className") as! String
        subjectLabel.text = subjectName

        let teacherName = passedData.object(forKey: "teacher") as! String
        teacherNameLabel.text = teacherName

    }





    @IBAction func update(){

    }

    @IBAction func delete(){
        let query = NCMBQuery(className: "RegisterInfo")
        query?.whereKey("subjectId", equalTo: passedData.object(forKey: "objectId"))
             query?.findObjectsInBackground({ (result, error) in
                 if error != nil{
                     print(error)

                 }else{
                    print(result)
                     
                    let query = NCMBQuery(className: "RegisterInfo")
                    query?.whereKey("student", equalTo: NCMBUser.current()?.object(forKey: "objectId"))
                    query?.findObjectsInBackground({ (result, error) in
                        if error != nil{
                            print(error)
                        }else{
                            print(result)
                            var myRegisterDataAll = result as! [NCMBObject]
                           
                            let myRegisterData = myRegisterDataAll[0] as! NCMBObject
                                print(myRegisterData)

                                myRegisterData.deleteInBackground({ (error) in
                                    if error != nil{
                                    print(error)
                                    }else{
                                    print("delete")
                                    }
                                })

                            
                            
                            
                            
                            
                        }
                    })
                 }
             })

    }

}

//
//  FriendPageViewController.swift
//  Instasample
//
//  Created by 樋口裕貴 on 2020/06/05.
//  Copyright © 2020 Yuki Higuchi. All rights reserved.
//

import UIKit
import NCMB

class FriendPageViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

        @IBOutlet var userImageView : UIImageView!
        @IBOutlet var userDisplayNameLabel : UILabel!
        @IBOutlet var userIntroductionTextView : UITextView!
        
        var subjectArray = [NCMBObject]()
           //    var array :[String] = ["kk"]
           var selectedIndex : IndexPath!
    
    var passedFriendData : NCMBUser!
    
           
           
           
           
        @IBOutlet var timeTableCollectionView : UICollectionView!
           
           
        
        override func viewDidLoad() {
            super.viewDidLoad()

           //画像を丸くする
            userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
            userImageView.layer.masksToBounds = true
        timeTableCollectionView.delegate = self
        timeTableCollectionView.dataSource = self
        
        let nib = UINib(nibName: "SubjectCollectionViewCell", bundle: Bundle.main)
        
        timeTableCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        // レイアウトを調整
            self.timeTableCollectionView.layer.borderColor = UIColor.black.cgColor
            self.timeTableCollectionView.layer.borderWidth = 1
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 50, height: 80)
            timeTableCollectionView.collectionViewLayout = layout
            
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            let user = passedFriendData
            
            userDisplayNameLabel.text = user?.object(forKey: "userName") as! String
    //        userIntroductionTextView.text = user?.object(forKey: "introduction") as! String
            self.navigationItem.title = user?.userName
            
            
            let file = NCMBFile.file(withName: passedFriendData.objectId, data: nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error != nil{
                    print(error)
                }else{
                    let image = UIImage(data: data!)
                    self.userImageView.image = image
                }
            }
            loadData()
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            print(subjectArray)
            print(subjectArray.count)
            return subjectArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SubjectCollectionViewCell
            
            print(subjectArray[indexPath.row])
            cell.subjectTextLabel.text = subjectArray[indexPath.row].object(forKey: "className") as! String
            
            
            return cell
        }
        /// 横のスペース
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            
            return 0.0
            
        }
        
        /// 縦のスペース
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            
            return 0.0
            
        }
        
        func loadData (){
            let query = NCMBQuery(className: "RegisterInfo")
            //        print(NCMBQuery(className: "Class"))
            query?.whereKey("student", equalTo: passedFriendData.objectId)
            query?.findObjectsInBackground({ (result, error) in
                if error != nil{
                    print(error)
                }else{
                    print(result)
                    self.subjectArray.removeAll()
                    var objects = result as! [NCMBObject]
                    //                var classObjArray = [String]()
                    
                    for i in objects{
                        print(objects.count)
                        let classId = i.object(forKey: "subjectId") as! String
                        print(classId)
                        //                    print(className)
                        //                    classObjArray.append(className)
                        //                    self.timeTableCollectionView.reloadData()
                        //                    print(self.subjectArray)
                        let query = NCMBQuery(className: "Class")
                        query?.whereKey("objectId", equalTo: classId)
                        query?.findObjectsInBackground({ (result, error) in
                            if error != nil{
                                print(error)
                            }else{
                                
                                print(result)
                                var allClassData = result as! [NCMBObject]
                                for classData in allClassData{
                                    self.subjectArray.append(classData)
                                    print(self.subjectArray.count)
                                    
                                    self.timeTableCollectionView.reloadData()
                                    
                                }
                                if self.subjectArray.count == objects.count {
                                    self.addEmptyClass()
                                }
                                
                               
                                
                            }
                        })
                        
                    }
                }
            })
            //        timeTableCollectionView.reloadData()
        }
        func addEmptyClass(){
            for i in 0...35 {
                var flag = true
                for subjectData in subjectArray{
                    print(subjectData)
                    print(i)
                    if subjectData.object(forKey: "time")as! Int == i {
                        flag=false
                    }
                }
                
                
                if flag == true {
                    let emptyClass = NCMBObject(className: "Class")
                    emptyClass?.setObject(i, forKey: "time")
                    emptyClass?.setObject("", forKey: "className")
                    subjectArray.append(emptyClass!)
                }
            }
            sortClassData()
        }
        func sortClassData () {
            var sortedData  = [NCMBObject]()
            for i in 0...35{
                for classData in subjectArray{
                    if classData.object(forKey: "time") as! Int == i{
                        sortedData.append(classData)
                    }
                }
                
                
            }
            subjectArray = sortedData
        }
        
    

    
}

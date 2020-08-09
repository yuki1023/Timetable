//
//  ViewController.swift
//  Instasample
//
//  Created by 樋口裕貴 on 2020/04/22.
//  Copyright © 2020 Yuki Higuchi. All rights reserved.
//

import UIKit
import NCMB

class TimeTableViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    
    var subjectArray = [NCMBObject]()
    //    var array :[String] = ["kk"]
    var selectedIndex : IndexPath!
    
    
    
    
    @IBOutlet var timeTableCollectionView : UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeTableCollectionView.delegate = self
        timeTableCollectionView.dataSource = self
        
        let nib = UINib(nibName: "SubjectCollectionViewCell", bundle: Bundle.main)
        
        timeTableCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        // レイアウトを調整
//        
        //        loadData()
        self.timeTableCollectionView.layer.borderColor = UIColor.black.cgColor
        self.timeTableCollectionView.layer.borderWidth = 1
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 95)
        timeTableCollectionView.collectionViewLayout = layout
        
    }
    override func viewWillAppear(_ animated: Bool) {
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
        query?.whereKey("student", equalTo: NCMBUser.current()?.objectId)
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                print(error)
            }else{
                print(result)
                self.subjectArray.removeAll()
                var objects = result as! [NCMBObject]
                //                var classObjArray = [String]()
                print(objects)
                
                if objects.count == 0{
                    self.addEmptyClass()
                    
                    self.timeTableCollectionView.reloadData()
                    
                }else{
                
                for i in objects{
                    
                    print(objects)
                    let classId = i.object(forKey: "subjectId") as! String
                    
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
                                print(self.subjectArray)
                                
                                self.timeTableCollectionView.reloadData()
                                
                            }
                            if self.subjectArray.count == objects.count {
                                self.addEmptyClass()
                            }
                            
                            
                           
                            
                        }
                    })
                    
                }
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
                    print(sortedData)
                }
            }
            
            
        }
        subjectArray = sortedData
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
      
    
        
        self.performSegue(withIdentifier: "toList", sender: nil)
        
        
        
        print(indexPath)
    }
    
    
    
    //値渡しの関数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toList"{
            //次の画面の取得
            let NameListViewController = segue.destination as! NameListViewController
            
            
            NameListViewController.passedClassData = subjectArray[selectedIndex.row]
            
            
            
            
            
            
            
            
        }
    }
    
    
    
    
}

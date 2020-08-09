//
//  SubjectCollectionViewCell.swift
//  Instasample
//
//  Created by 樋口裕貴 on 2020/05/21.
//  Copyright © 2020 Yuki Higuchi. All rights reserved.
//

import UIKit

class SubjectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var subjectTextLabel : UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        
    }

}


//
//  ReusableLoadingItemViewCell.swift
//  TF_iOS_Movies_Yago
//
//  Created by Desenvolvimento on 21/11/21.
//

import UIKit
import SwiftUI

class ReusableLoadingItemViewCell: UICollectionReusableView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.color = UIColor.systemOrange
        // Initialization code
    }
    
}

//
//  RoundImageView.swift
//  HW_106
//
//  Created by Азат Зиганшин on 30.10.2023.
//

import Foundation
import UIKit

class RoundImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2.0
        layer.masksToBounds = true
    }
}

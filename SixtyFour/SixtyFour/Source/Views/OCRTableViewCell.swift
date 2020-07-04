//
//  OCRTableViewCell.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 04/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import UIKit

class OCRTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var confidenceLabel: UILabel!
    @IBOutlet var ocrId: UILabel!
    @IBOutlet var orcImage: UIImageView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

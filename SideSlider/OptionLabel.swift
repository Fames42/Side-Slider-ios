//
//  OptionLabel.swift
//  SideSlider
//
//  Created by Admin on 12/15/20.
//

import Foundation
import UIKit

@IBDesignable class OptionLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 8.0
    @IBInspectable var bottomInset: CGFloat = 8.0
    @IBInspectable var leftInset: CGFloat = 12.0
    @IBInspectable var rightInset: CGFloat = 12.0
    var selectedColor = UIColor(red: 255.0/255, green: 130.0/255, blue: 101.0/255, alpha: 1.0)
    var notSelectedColor = UIColor(red: 230.0/255, green: 245.0/255, blue: 247.0/255, alpha: 1.0)
    var fullText: String = ""
    
    var isSelected: Bool = false {
        didSet {
            if isSelected == true {
                self.backgroundColor = selectedColor
            } else {
                self.backgroundColor = notSelectedColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    func commonInit() {
        let tap = UIGestureRecognizer(target: self, action: #selector(didTapped))
        addGestureRecognizer(tap)
        
        self.isUserInteractionEnabled = true
        self.textAlignment = .center
        self.isSelected = false
        self.textColor = UIColor(red: 39.0/255, green: 65.0/255, blue: 88.0/255, alpha: 1.0)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
    
    @objc func didTapped() {
        print("WTF")
        isSelected = !isSelected
    }
}

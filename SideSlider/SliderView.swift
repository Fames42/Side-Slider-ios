//
//  SliderView.swift
//  SideSlider
//
//  Created by Admin on 12/15/20.
//

import UIKit
import Foundation

protocol SliderViewScrolled {
    func scroll(to section: String, with delay: Bool)
    func sliderExpanded()
    func sliderCollapsed()
}

protocol UnselectLabels {
    func unselectRest(_ except: UILabel?)
}


class SliderView: UIView {
    var sections: [String] = [] {
        didSet {
            setupView()
        }
    }
    var labels: [OptionLabel] = []
    var fontSize:CGFloat = 18.0
    var spacing: CGFloat = 20
    var isExpanded = false {
        didSet {
            if oldValue != isExpanded {
                if self.isExpanded {
                    expand()
                } else {
                    collapse()
                }
            }
        }
    }
    var offset: CGFloat = 15.0
    var maxSize: CGFloat = 0.0
    var minSize: CGFloat = 30.0
    var scrollDelegate: SliderViewScrolled?

    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        self.backgroundColor = .clear

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        panGestureRecognizer.delegate = self
        self.addGestureRecognizer(panGestureRecognizer)

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(sender:)))
        longPressGesture.minimumPressDuration = 0.3
        longPressGesture.delegate = self
        self.addGestureRecognizer(longPressGesture)
        
        var prevLabel: UILabel? = nil

        for section in sections {
            let label = OptionLabel(frame: CGRect.zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            let tap = LabelTapGesture(target: self, action: #selector(tapped(sender:)))
            tap.label = label
            tap.unselectDelegate = self
            label.addGestureRecognizer(tap)
            label.textAlignment = .left

            label.font = UIFont(name: "GillSansProCyrillic-Medium", size: fontSize + 1.0) ?? UIFont.systemFont(ofSize: fontSize)
            label.topInset = 12
            label.bottomInset = 12
            label.leftInset = 15
            label.rightInset = 15
            label.notSelectedColor = .white
            label.isSelected = false
            label.text = String(section.first ?? "0")
            label.fullText = section
            label.frame = CGRect(x: 0, y: 0, width: label.intrinsicContentSize.width, height:   label.intrinsicContentSize.height)
            label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]

            self.addSubview(label)
            labels.append(label)

            if let prev = prevLabel {
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
                label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
                label.topAnchor.constraint(equalTo: prev.topAnchor, constant: prev.intrinsicContentSize.height + offset).isActive = true
            } else {
                label.isSelected = true
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
                label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
                label.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
            }
            
            prevLabel = label
        }
        minSize = (labels.map({$0.intrinsicContentSize.width}).max() ?? 30.0)
        
        let longest = labels.map({$0.fullText}).max(by: {$0.count < $1.count})
        labels[0].text = longest
        maxSize = labels[0].intrinsicContentSize.width
        labels[0].text = String(labels[0].fullText.first ?? "0")
    }
    
    func collapse() {
        self.backgroundColor = .clear

        for label in self.labels {
            label.text = String(label.fullText.first ?? "0")
            label.textAlignment = .left
        }
        scrollDelegate?.sliderCollapsed()

        UIView.animate(withDuration: 0.2,
            animations: {
                self.center.x += self.maxSize/2 - self.minSize / 2
                self.layoutIfNeeded()
            }, completion: {_ in
                // do something
            })

    }
    
    func expand() {
        self.backgroundColor = .white
        for label in self.labels {
            label.text = label.fullText
            label.textAlignment = .center
        }
        
        self.scrollDelegate?.sliderExpanded()
        
        UIView.animate(withDuration: 0.2,
            animations: {
                self.center.x -= self.maxSize - self.minSize
                self.layoutIfNeeded()
            }, completion: nil)
    }
    
    func getContentHeight() -> CGFloat {
        return labels.reduce(0, {$0 + $1.intrinsicContentSize.height}) + CGFloat(labels.count - 1) * offset
    }
    
    @objc func tapped(sender: LabelTapGesture) {
        sender.unselectDelegate?.unselectRest(nil)
        scrollDelegate?.scroll(to: sender.label.fullText, with: false)
        UIView.animate(withDuration: 0.2,
            animations: {
                sender.label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                sender.label.isSelected = !sender.label.isSelected
            },
            completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    sender.label.transform = CGAffineTransform.identity
                }
            })
    }
    
    @objc func didPan(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self)
        panMoved(to: location)
        
        if sender.state == .began {
            isExpanded = true
        } else if sender.state == .changed {
            // Code
        } else if sender.state == .ended {
            isExpanded = false
        }
    }
        
    @objc func didLongPress(sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self)
        panMoved(to: location)
        if sender.state == .began {
            isExpanded = true
        } else if sender.state == .ended {
            isExpanded = false
        }
    }
    
    func panMoved(to location: CGPoint, with delay: Bool = true) {
        for (i, label) in labels.enumerated() {
            
            // Convert the location of the obstacle view to this view controller's view coordinate system
            let labelFrame = self.convert(label.frame, from: label.superview)
            
            // Check if the touch is inside the obstacle view
            if labelFrame.contains(location) {
                if labels[i].isSelected != true {
                    unselectRest(label)
                    scrollDelegate?.scroll(to: label.fullText, with: delay)
                }
            }
        }
    }
    
}

extension SliderView: UnselectLabels {
    func unselectRest(_ except: UILabel? = nil) {
        labels.forEach({label in
            label.isSelected = false
        })
        if let label = except as? OptionLabel {
            label.isSelected = true
        }
    }
    
}

extension SliderView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

class LabelTapGesture: UITapGestureRecognizer {
    var label: OptionLabel = OptionLabel()
    var unselectDelegate: UnselectLabels?
}

//
//  ViewController.swift
//  SideSlider
//
//  Created by Admin on 12/15/20.
//

import UIKit

class ViewController: UIViewController {

    let slider = SliderView(frame: CGRect.zero)
    var scrollTask: DispatchWorkItem?
    let biscay = UIColor(red: 39.0/255, green: 65.0/255, blue: 88.0/255, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = biscay
        
        //MARK: sliderView
        slider.scrollDelegate = self
        self.slider.sections = ["Check", "That", "View", "Thoroughly"]
        self.view.addSubview(self.slider)
        let margins = view.layoutMarginsGuide
        slider.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        slider.heightAnchor.constraint(equalToConstant: slider.getContentHeight()).isActive = true
        slider.minWidthConstraint.isActive = true
        slider.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
    }


}

extension ViewController: SliderViewScrolled {
    func scroll(to section: String, with delay: Bool) {
        self.scrollTask?.cancel()
        let task = DispatchWorkItem {
//            if let section = self.menu.indices.first(where: {self.menu[$0].name == section}) {
//                self.tableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
//            }
        }
        self.scrollTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (delay ? 0.4 : 0.0), execute: task)
    }
}


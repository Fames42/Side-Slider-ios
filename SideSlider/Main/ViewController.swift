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
    let biscay = UIColor(red: 47.0/255, green: 77.0/255, blue: 106.0/255, alpha: 1.0)
    var leadingAnchor: NSLayoutConstraint!
    var menu: [MenuCategory] = [MenuCategory(name: "Sides", description: "Sides", dishes: [Dish(name: "Check", price: "$4.3", description: "Checkcheckcheck", tags: [], id: nil)])]
    var headerPositions: [CGFloat] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initializeData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = biscay
        
        tableView.register(UINib(nibName: "DishTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")

        //MARK: sliderView
        slider.scrollDelegate = self
        self.slider.sections = ["Check", "That", "View", "Thoroughly", "ERULAN", "AND", "DAULET"]
        self.view.addSubview(self.slider)
        let margins = view.layoutMarginsGuide
        
        slider.heightAnchor.constraint(equalToConstant: slider.getContentHeight()).isActive = true
        leadingAnchor = slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width - slider.minSize)
        leadingAnchor.isActive = true
        slider.widthAnchor.constraint(equalToConstant: slider.maxSize).isActive = true
        slider.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
    }

}

extension ViewController: SliderViewDelegate {
    func scroll(to section: String, with delay: Bool) {
        self.scrollTask?.cancel()
        let task = DispatchWorkItem {
            if let section = self.menu.indices.first(where: {self.menu[$0].name == section}) {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
            }
        }
        self.scrollTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (delay ? 0.4 : 0.0), execute: task)
    }
    
    func sliderExpanded() {
        leadingAnchor.constant = view.bounds.width - slider.maxSize
    }
    
    func sliderCollapsed() {
        leadingAnchor.constant = view.bounds.width - slider.minSize
        UIView.animate(withDuration: 0.1, animations: {
            self.slider.layoutIfNeeded()
        })
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu[section].dishes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! DishTableViewCell
        cell.dish = menu[indexPath.section].dishes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        let attributes = [NSAttributedString.Key.font : UIFont(name: "GaramondPremrPro", size: 24.0) ?? UIFont.systemFont(ofSize: 20.0), NSAttributedString.Key.foregroundColor:  UIColor.white] as [NSAttributedString.Key : Any]
        let attributedString = NSAttributedString(string: self.menu[section].name!, attributes: attributes)
        label.attributedText = attributedString

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = self.menu[section].name!.height(withConstrainedWidth: UIScreen.main.bounds.width, font: UIFont(name: "GaramondPremrPro", size: 24.0) ?? UIFont.systemFont(ofSize: 20.0))
        return height + 45
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if tableView.isDragging {
//            let offset = scrollView.contentOffset.y
//            let indices = 0...(headerPositions.count - 1)
//            let section = zip(headerPositions.map({abs($0 - offset)}), indices).min(by: {$0.0 < $1.0})!.1
//            if headerPositions[section] - offset <= tableView.bounds.height/2 {
//                self.slider.unselectRest(self.slider.labels[section])
//            } else if section != 0 {
//                self.slider.unselectRest(self.slider.labels[section - 1])
//            }
//        }
    }
    
    func calculateHeaderPositions() {
        headerPositions.append(35.0)
        for category in menu.dropLast() {
            let height = category.name!.height(withConstrainedWidth: UIScreen.main.bounds.width, font: UIFont(name: "GaramondPremrPro", size: 24.0) ?? UIFont.systemFont(ofSize: 20.0)) + 62.5
            headerPositions.append(CGFloat(160 * category.dishes.count) + height)
        }
        headerPositions = headerPositions
            .reduce(into: []) { $0.append(($0.last ?? 0) + $1) }
        print(headerPositions)
    }

}

extension ViewController {
    func initializeData() {
        if let string = loadFileAsString() {
            let data = Data(string.utf8)
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>] {
                    let menu = (jsonArray[0]["menu"] as! Dictionary<String, Any>)["categories"] as! [Dictionary<String, Any>]
                    print(menu)
                    var dishTypes: [MenuCategory] = []
                    for dishType in menu {
                        let name = dishType["name"] as! String
                        let description = dishType["description"] as! String
                        let dishesJSON = dishType["dishes"] as! [Dictionary<String, Any>]
                        var dishes: [Dish] = []
                        for dish in dishesJSON {
                            let name = dish["name"] as! String
                            let description = dish["description"] as! String
                            let price = dish["price"] as! String
                            dishes.append(Dish(name: name, price: price, description: description, tags: [], id: nil))
                        }
                        dishTypes.append(MenuCategory(name: name, description: description, dishes: dishes))
                    }
                    self.menu = dishTypes
                    tableView.reloadData()
                } else {
                    print("Failed to load: bad json")
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func loadFileAsString() -> String? {
        if let path = Bundle.main.path(forResource: "restaurant", ofType: "txt") {
            let fm = FileManager()
            let exists = fm.fileExists(atPath: path)
            if(exists){
                let content = fm.contents(atPath: path)
                let contentAsString = String(data: content!, encoding: String.Encoding.utf8)
                return contentAsString
            }
        }
        return nil
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

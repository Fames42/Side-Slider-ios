//
//  DishTableViewCell.swift
//  SideSlider
//
//  Created by Admin on 12/29/20.
//

import UIKit

class DishTableViewCell: UITableViewCell {

    var dish: Dish? {
        didSet {
            dishName.text = dish?.name
            dishDescription.text = dish?.description
            dishPrice.text = dish?.price
        }
    }

    @IBOutlet weak var innerView: UIView!
    
    let dishName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GillSansProCyrillic-Medium", size: 18.0)
        label.textColor = UIColor(red: 39.0/255, green: 65.0/255, blue: 88.0/255, alpha: 1.0)
        return label
    }()
    
    let dishDescription: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 39.0/255, green: 65.0/255, blue: 88.0/255, alpha: 1.0)
        label.font = UIFont(name: "GillSansProCyrillic-Light", size: 14.0)
        label.numberOfLines = 3
        return label
    }()
    
    let dishPrice: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 39.0/255, green: 65.0/255, blue: 88.0/255, alpha: 1.0)
        label.font = UIFont(name: "GillSansProCyrillic-Medium", size: 15.0)
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

        contentView.backgroundColor = UIColor(red: 47.0/255.0, green: 77.0/255.0, blue: 106.0/255.0, alpha: 1.0)
        
        //MARK: innerView
        innerView.backgroundColor = UIColor(red: 222.0/255, green: 232.0/255, blue: 250.0/255, alpha: 1.0)
        innerView.layer.cornerRadius = 10
        innerView.layer.shadowColor = UIColor.black.cgColor
        innerView.layer.shadowOpacity = 0.1
        innerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        innerView.layer.shadowRadius = 1
        innerView.layer.masksToBounds = false
        innerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]

        //MARK: dishName
        innerView.addSubview(dishName)
        dishName.translatesAutoresizingMaskIntoConstraints = false
        dishName.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 10).isActive = true
        dishName.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -15).isActive = true
        dishName.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 15).isActive = true
        
        //MARK: dishPrice
        innerView.addSubview(dishPrice)
        dishPrice.translatesAutoresizingMaskIntoConstraints = false
        dishPrice.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 15).isActive = true
        dishPrice.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: -15).isActive = true
        
        //MARK: dishDescription
        innerView.addSubview(dishDescription)
        dishDescription.translatesAutoresizingMaskIntoConstraints = false
        dishDescription.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 15).isActive = true
        dishDescription.topAnchor.constraint(equalTo: dishName.bottomAnchor, constant: 15).isActive = true
        dishDescription.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -15).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

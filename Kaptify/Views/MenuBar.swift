//
//  MenuBar.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-08-09.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellIdentifier"
    
    let menuTitles = ["Album", "Comments"]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let horizontalBarView: UIView = {
        let bar = UIView()
        bar.backgroundColor = .white
        bar.layer.shadowColor = UIColor.black.cgColor
        bar.layer.shadowRadius = 2.0
        bar.layer.shadowOpacity = 0.2
        bar.layer.shadowOffset = CGSize(width: 2, height: 2)
        bar.layer.masksToBounds = false
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(collectionView)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        self.setupCollectionView()
        DispatchQueue.main.async {
            self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredVertically)
        }
        setupHorizontalBar()
        
    }
    func setupHorizontalBar() {
        
        addSubview(horizontalBarView)
        
        horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        horizontalBarView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/8).isActive = true
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.titleLabel.text = self.menuTitles[indexPath.item]
        cell.titleLabel.textColor = .white
        let font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        cell.titleLabel.font = font
        //cell.isSelected = indexPath.item == 0 ? true : false
       // cell.isHighlighted = indexPath.item == 0 ? true : false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            animateBar("left")
        } else {
            animateBar("right")
        }
    }
    
    func animateBar(_ direction: String) {
        if direction == "left" {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.horizontalBarView.frame.origin.x = self.frame.origin.x
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.horizontalBarView.frame.origin.x = self.frame.width / 2
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/2, height: frame.height)
    }
    
    fileprivate func setupCollectionView() {
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MenuCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Album"
        let blackColor: UIColor = .black
        label.layer.shadowColor = blackColor.cgColor
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 0.2
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let selectedFont = UIFont(name: "HelveticaNeue-Medium", size: 24)
    let unselectedFont = UIFont(name: "HelveticaNeue-Medium", size: 16)
    
    override var isHighlighted: Bool {
        didSet {
            titleLabel.font = isHighlighted ? selectedFont : unselectedFont
        }
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? selectedFont : unselectedFont
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    func setupViews() {
        backgroundColor = .clear
        
        self.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


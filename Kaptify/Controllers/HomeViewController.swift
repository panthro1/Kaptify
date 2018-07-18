//
//  HomeViewController.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-06-24.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit
import Firebase

struct object: Decodable {
    let feed: Feed?
}

struct Feed: Decodable {
    let title: String?
    let id: String?

    
    struct Author: Decodable {
        let name: String?
        let uri: String?
    }
    
    let author: Author?
    struct Link: Decodable {
        let url: String?
        private enum CodingKeys: String, CodingKey {
            case url = "self"
        }
    }
    let links: [Link]?
    let copyright: String?
    let country: String?
    let icon: String?
    let updated: String?
    
    let results: [Album]?
}


struct Album: Decodable {
    let artistName: String?
    let id: String?
    let releaseDate: String?
    let name: String?
    let artworkUrl100: String?
    let kind: String?
    let copyright: String?
    let artistId: String?
    let artistUrl: String?
    struct Genre: Decodable {
        let genreId: String?
        let name: String?
        let url: String?
    }
    let genres: [Genre]?
    let url: String?
}


class HomeViewController: UIViewController {
    
    let cellIdentifier = "cellIdentifier"
    let objects = ["Yeezus", "Lost & Found", "Scorpion", "Lol", "hi", "MBDTF", "Flower Boy", "Nirvana", "Beasty boys", "For the only time ever I will die"]
    let names = ["Kanye West", "Jorja Smith", "Drake", "meme", "sup", "Kanye West", "Tyler the Creator", "Nirvana", "Beasty boys", "Sahil"]
    
    //MARK: Home View UI Elements
    let albumCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 150, height: 195)
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
    }()
    
    let recentReleaseLabel: UILabel = {
        let rLabel = UILabel()
        rLabel.text = "Recent Releases"
        rLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
        rLabel.textColor = .white
        rLabel.translatesAutoresizingMaskIntoConstraints = false
        return rLabel
    }()
    
    let collectionBg: UIImageView = {
        let imV = UIImageView()
        let im = UIImage(named: "collection_bg")
        imV.image = im
        imV.translatesAutoresizingMaskIntoConstraints = false
        imV.contentMode = .scaleAspectFill
        return imV
    }()
    
    lazy var optionsButton: UIButton = {
        let options = UIButton(type: .system)
        let optionsImage = UIImage(named: "options_btn")
        let optionsImageView = UIImageView(image: optionsImage)
        optionsImageView.contentMode = .scaleAspectFill
        options.setImage(optionsImageView.image, for: .normal)
        options.translatesAutoresizingMaskIntoConstraints = false
        options.addTarget(self, action: #selector(handleOptions), for: .touchUpInside)
        return options
    }()

    //MARK: Activity Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(r: 51, b: 51, g: 51)
        
        checkIfValidUser()
        setupNavBar()
        
        albumCollection.delegate = self
        albumCollection.dataSource = self
        
        setupUIElements()
        
        //Networking (Remove later)
        let jsonString = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/25/explicit.json"
        guard let url = URL(string: jsonString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // check error
            // check response (200)
            
            guard let data = data else { return }
//            let dataString = String(data: data, encoding: .utf8)
//            print(dataString)
            
            do {
                let obj = try JSONDecoder().decode(object.self, from: data)
                print(obj.feed?.results?.first?.name)
            } catch let jsonError {
                print("Error with json", jsonError)
            }
            
        }.resume()
    }
    
    func setupUIElements() {
        self.view.addSubview(collectionBg)
        self.view.addSubview(recentReleaseLabel)
        self.view.addSubview(albumCollection)
        
        setupCollectionBg()
        setupAlbumCollection()
        setupRecentReleaseLabel()
    }
    
    //MARK: Setup view constraints
    func setupAlbumCollection() {
        //load cell from nib
        self.albumCollection.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        //self.albumCollection.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        // Setup collection constraints
//        albumCollection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        albumCollection.topAnchor.constraint(equalTo: recentReleaseLabel.bottomAnchor, constant: 20).isActive = true
//        albumCollection.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/3).isActive = true
//        albumCollection.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    func setupCollectionBg() {
        collectionBg.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        collectionBg.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        collectionBg.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        collectionBg.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        collectionBg.heightAnchor.constraint(equalToConstant: 229).isActive = true
    }
    
    func setupRecentReleaseLabel() {
        recentReleaseLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        recentReleaseLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        recentReleaseLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func checkIfValidUser() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleOptions), with: nil, afterDelay: 0)
            handleOptions()
        }
    }
    
    @objc func handleOptions() {
        do {
            try Auth.auth().signOut()
        } catch let logoutErr {
            print(logoutErr)
        }
        
        let registerController = RegisterViewController()
        present(registerController, animated: true, completion: nil)
    }
    
    func setupNavBar() {
        // add leftButton
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: optionsButton)
        // add title 
        let title = UIImage(named: "Logo_text")
        let imageView = UIImageView(image: title)
        imageView.contentMode = .scaleAspectFill
        self.navigationItem.titleView = imageView
    }
}

//MARK: Extension with Collection View protocol methods
extension HomeViewController:  UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AlbumCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AlbumCollectionViewCell
        cell.albumImage.image = UIImage(named: "mbdtf")
        cell.albumLabel.text = self.objects[indexPath.item]
        cell.artistLabel.text = self.names[indexPath.item]
        cell.artistLabel.textColor = .white
        cell.albumLabel.textColor = .white
        cell.backgroundColor = .clear //UIColor(r: 51, b: 51, g: 51)
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        albumCollection.frame = CGRect(x: 0, y: recentReleaseLabel.frame.origin.y + recentReleaseLabel.frame.height + 20, width: view.frame.width, height: self.view.frame.height - (self.tabBarController?.tabBar.frame.height)! + self.recentReleaseLabel.frame.height)
    }
    
}

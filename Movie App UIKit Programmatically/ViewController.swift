//
//  ViewController.swift
//  Movie App UIKit Programmatically
//
//  Created by Jonathan Ricky Sandjaja on 30/01/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        title = "Movie"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Now Playing"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var titleLabel2: UILabel = {
        let label = UILabel()
        label.text = "Upcoming"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var collectionView1: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 170)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var collectionView2: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 170)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell2")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return 10
        }
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1 {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell1.backgroundColor = .red
            return cell1
        } else {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath)
            cell2.backgroundColor = .blue
            return cell2
        }
    }
    
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView1)
        view.addSubview(titleLabel2)
        view.addSubview(collectionView2)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            
            collectionView1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView1.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            collectionView1.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            collectionView1.heightAnchor.constraint(equalTo: collectionView1.widthAnchor, multiplier: 0.5),
            
            titleLabel2.topAnchor.constraint(equalTo: collectionView1.bottomAnchor, constant: 16),
            titleLabel2.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            collectionView2.topAnchor.constraint(equalTo: titleLabel2.bottomAnchor),
            collectionView2.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            collectionView2.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            collectionView2.heightAnchor.constraint(equalTo: collectionView2.widthAnchor, multiplier: 0.5),
        ])
    }

}


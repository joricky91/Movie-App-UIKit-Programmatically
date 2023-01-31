//
//  ViewController.swift
//  Movie App UIKit Programmatically
//
//  Created by Jonathan Ricky Sandjaja on 30/01/23.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    let vm = MovieViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        vm.getNowPlayingMovie()
        bindVM()
        title = "Movie"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func bindVM() {
        vm.$nowPlaying.sink { [weak self] _ in
            self?.collectionView1.reloadData()
        }.store(in: &cancellables)
    }
    
//    private func fetchData() {
//        vm.getNowPlayingMovie()
//    }
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    lazy var contentView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    lazy var titleLabel3: UILabel = {
        let label = UILabel()
        label.text = "Top Rated"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var collectionView1: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 220)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var collectionView2: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 220)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell2")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var collectionView3: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 220)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell3")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubview(titleLabel)
        contentView.addArrangedSubview(collectionView1)
        contentView.addArrangedSubview(titleLabel2)
        contentView.addArrangedSubview(collectionView2)
        contentView.addArrangedSubview(titleLabel3)
        contentView.addArrangedSubview(collectionView3)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            collectionView1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView1.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65),
            
            collectionView2.topAnchor.constraint(equalTo: titleLabel2.bottomAnchor),
            collectionView2.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65),
            
            collectionView3.topAnchor.constraint(equalTo: titleLabel3.bottomAnchor),
            collectionView3.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65),
        ])
    }

}


extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return vm.nowPlaying.count
        } else if collectionView == collectionView2 {
            return 10
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1 {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
            let data: Movie
            data = vm.nowPlaying[indexPath.row]
            let stringURL = "https://image.tmdb.org/t/p/w1280/\(data.poster ?? "")"
            if let url = URL(string: stringURL) {
                cell1.moviePoster.downloadImage(from: url)
            }
            cell1.movieTitle.text = data.title
            return cell1
        } else if collectionView == collectionView2 {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CustomCell
            return cell2
        } else {
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as! CustomCell
            return cell3
        }
    }
}


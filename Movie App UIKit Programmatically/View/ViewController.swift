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
    
    lazy var text: UITextView = {
        let text = UITextView()
        text.text = "Hello"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        vm.getNowPlayingMovie()
        vm.getUpcomingMovie()
        vm.getTopRatedMovie()
        bindVM()
        title = "Movie"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func bindVM() {
        vm.$nowPlaying.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView1.reloadData()
            }
        }.store(in: &cancellables)
        
        vm.$upcoming.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView2.reloadData()
            }
        }.store(in: &cancellables)
        
        vm.$topRated.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView3.reloadData()
            }
        }.store(in: &cancellables)
    }
    
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
    
    func reusableTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func reusableCollectionView(identifier: String) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 220)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }
    
    lazy var nowPlayingLabel = reusableTitleLabel(text: "Now Playing")
    lazy var upcomingLabel = reusableTitleLabel(text: "Upcoming")
    lazy var topRatedLabel = reusableTitleLabel(text: "Top Rated")
    
    lazy var collectionView1 = reusableCollectionView(identifier: "cell")
    lazy var collectionView2 = reusableCollectionView(identifier: "cell2")
    lazy var collectionView3 = reusableCollectionView(identifier: "cell3")
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubview(text)
        contentView.addArrangedSubview(nowPlayingLabel)
        contentView.addArrangedSubview(collectionView1)
        contentView.addArrangedSubview(upcomingLabel)
        contentView.addArrangedSubview(collectionView2)
        contentView.addArrangedSubview(topRatedLabel)
        contentView.addArrangedSubview(collectionView3)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nowPlayingLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            collectionView1.topAnchor.constraint(equalTo: nowPlayingLabel.bottomAnchor),
            collectionView1.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65),
            
            collectionView2.topAnchor.constraint(equalTo: upcomingLabel.bottomAnchor),
            collectionView2.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65),
            
            collectionView3.topAnchor.constraint(equalTo: topRatedLabel.bottomAnchor),
            collectionView3.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65),
        ])
    }

}


extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func reusableCollectionViewCellSetting(collectionView: UICollectionView, identifier: String, indexPath: IndexPath) -> CustomCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CustomCell
        let data: Movie
        data = vm.nowPlaying[indexPath.row]
        let stringURL = "https://image.tmdb.org/t/p/w1280/\(data.poster ?? "")"
        if let url = URL(string: stringURL) {
            cell.moviePoster.downloadImage(from: url)
        }
        cell.movieTitle.text = data.title
        return cell
    }
    
    func navigateToAnotherViewController(movieID: Int) {
        let movieDetailsView = MovieDetailsViewController()
        movieDetailsView.movieID = movieID
        movieDetailsView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(movieDetailsView, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return vm.nowPlaying.count
        } else if collectionView == collectionView2 {
            return vm.upcoming.count
        } else {
            return vm.topRated.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1 {
            return reusableCollectionViewCellSetting(collectionView: collectionView, identifier: "cell", indexPath: indexPath)
        } else if collectionView == collectionView2 {
            return reusableCollectionViewCellSetting(collectionView: collectionView, identifier: "cell2", indexPath: indexPath)
        } else {
            return reusableCollectionViewCellSetting(collectionView: collectionView, identifier: "cell3", indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionView1 {
            navigateToAnotherViewController(movieID: vm.nowPlaying[indexPath.row].id)
        } else if collectionView == collectionView2 {
            navigateToAnotherViewController(movieID: vm.upcoming[indexPath.row].id)
        } else {
            navigateToAnotherViewController(movieID: vm.topRated[indexPath.row].id)
        }
    }
}


//
//  MovieDetailsViewController.swift
//  Movie App UIKit Programmatically
//
//  Created by Jonathan Ricky Sandjaja on 31/01/23.
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController {
    var movieID: Int = 0
    
    let vm = MovieViewModel()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        bindVM()
        vm.getMovieDetails(movieID: self.movieID)
        vm.getMovieVideos(movieID: self.movieID)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func bindVM() {
        vm.objectWillChange.sink { _ in
            DispatchQueue.main.async {
                self.movieTitle.text = self.vm.movieDetails?.title
                self.movieBackdrop.downloadImage(from: URL(string: "https://image.tmdb.org/t/p/w1000_and_h563_face/\(self.vm.movieDetails?.backdrop ?? "")")!)
                self.movieReleaseDate.text = self.vm.movieDetails?.releaseDate
                self.movieRuntime.text = "Runtime: \(self.vm.movieDetails?.runtime ?? 0) minutes"
                self.movieGenre.text = self.vm.arrangeMovieGenresInHorizontalText()
                self.movieOverview.text = self.vm.movieDetails?.overview
                self.tableView.reloadData()
            }
        }.store(in: &cancellables)
    }
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    func reusableStackView(spacing: CGFloat) -> UIStackView {
        let stack = UIStackView()
        stack.spacing = spacing
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    lazy var stackView = reusableStackView(spacing: 10)
    lazy var topStackView = reusableStackView(spacing: 5)
    lazy var middleStackView = reusableStackView(spacing: 0)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "videoCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var movieTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var movieBackdrop: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var movieReleaseDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var movieRuntime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var movieGenre: UILabel = {
        let label = UILabel()
        label.text = "Genre: Romance, Animation, Drama"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var movieOverview: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var videosTitleText: UILabel = {
        let label = UILabel()
        label.text = "Videos"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(topStackView)
        topStackView.addArrangedSubview(movieTitle)
        topStackView.addArrangedSubview(movieBackdrop)
        stackView.addArrangedSubview(middleStackView)
        middleStackView.addArrangedSubview(movieReleaseDate)
        middleStackView.addArrangedSubview(movieRuntime)
        middleStackView.addArrangedSubview(movieGenre)
        stackView.addArrangedSubview(movieOverview)
        stackView.addArrangedSubview(videosTitleText)
        stackView.addArrangedSubview(tableView)
    }
    
    func getTableViewHeightMultiplier() -> CGFloat {
        if vm.videos.count < 4 {
            return 0.3
        } else if vm.videos.count > 4 && vm.videos.count < 8 {
            return 0.4
        } else {
            return 0.5
        }
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            topStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            topStackView.topAnchor.constraint(equalTo: stackView.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            movieTitle.topAnchor.constraint(equalTo: topStackView.topAnchor),
            movieTitle.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor, constant: 16),
            
            movieBackdrop.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 5),
            movieBackdrop.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor, constant: -16),
            movieBackdrop.heightAnchor.constraint(equalTo: topStackView.widthAnchor, multiplier: 0.57),
            
            middleStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            middleStackView.topAnchor.constraint(equalTo: movieBackdrop.bottomAnchor, constant: 16),
            middleStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            middleStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

            movieReleaseDate.topAnchor.constraint(equalTo: middleStackView.topAnchor),
            movieReleaseDate.leadingAnchor.constraint(equalTo: middleStackView.leadingAnchor, constant: 16),

            movieRuntime.topAnchor.constraint(equalTo: movieReleaseDate.bottomAnchor),
            movieRuntime.leadingAnchor.constraint(equalTo: middleStackView.leadingAnchor, constant: 16),

            movieGenre.topAnchor.constraint(equalTo: movieRuntime.bottomAnchor),
            movieGenre.leadingAnchor.constraint(equalTo: middleStackView.leadingAnchor, constant: 16),
            movieGenre.trailingAnchor.constraint(equalTo: middleStackView.trailingAnchor, constant: -16),

            movieOverview.topAnchor.constraint(equalTo: middleStackView.bottomAnchor, constant: 16),
            movieOverview.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            movieOverview.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),

            videosTitleText.topAnchor.constraint(equalTo: movieOverview.bottomAnchor, constant: 10),
            videosTitleText.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),

            tableView.topAnchor.constraint(equalTo: videosTitleText.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: getTableViewHeightMultiplier()),
        ])
    }
}


extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath)
        cell.textLabel?.text = vm.videos[indexPath.row].name
        cell.accessoryView = UIImageView(image: UIImage(systemName: "play.rectangle.fill"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = URL(string: "https://www.youtube.com/watch?v=\(vm.videos[indexPath.row].key)")
        guard let unwrappedURL = url else { return }
        UIApplication.shared.open(unwrappedURL)
    }
}

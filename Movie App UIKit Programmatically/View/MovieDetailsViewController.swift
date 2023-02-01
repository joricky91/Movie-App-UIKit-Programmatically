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
                self.movieOverview.text = self.vm.movieDetails?.overview
                self.tableView.reloadData()
            }
        }.store(in: &cancellables)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "videoCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
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
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
        view.addSubview(movieTitle)
        view.addSubview(movieBackdrop)
        view.addSubview(movieReleaseDate)
        view.addSubview(movieRuntime)
        view.addSubview(movieGenre)
        view.addSubview(movieOverview)
        view.addSubview(videosTitleText)
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            movieTitle.topAnchor.constraint(equalTo: safeArea.topAnchor),
            movieTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            movieBackdrop.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 5),
            movieBackdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            movieBackdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            movieBackdrop.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.57),

            movieReleaseDate.topAnchor.constraint(equalTo: movieBackdrop.bottomAnchor, constant: 16),
            movieReleaseDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            movieRuntime.topAnchor.constraint(equalTo: movieReleaseDate.bottomAnchor),
            movieRuntime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            movieGenre.topAnchor.constraint(equalTo: movieRuntime.bottomAnchor),
            movieGenre.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            movieOverview.topAnchor.constraint(equalTo: movieGenre.bottomAnchor, constant: 10),
            movieOverview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            movieOverview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            videosTitleText.topAnchor.constraint(equalTo: movieOverview.bottomAnchor, constant: 10),
            videosTitleText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            tableView.topAnchor.constraint(equalTo: videosTitleText.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
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

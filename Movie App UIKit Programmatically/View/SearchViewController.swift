//
//  SearchViewController.swift
//  Movie App UIKit Programmatically
//
//  Created by Jonathan Ricky Sandjaja on 01/02/23.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        return search
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
   
    func setupViews() {
        navigationItem.searchController = searchController
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        var safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: safeArea.heightAnchor),
        ])
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        cell.textLabel?.text = "Item"
        return cell
    }
    
    
}

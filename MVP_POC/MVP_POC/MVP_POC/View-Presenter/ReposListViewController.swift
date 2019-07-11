//
//  ReposListViewController.swift
//  MVVM_POC
//
//  Created by Moayad Al kouz on 09/07/2019.
//  Copyright © 2019 Moayad Al kouz. All rights reserved.
//

import UIKit

class ReposListViewController: UIViewController {

    //IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    //Properties
    private var presenter: ReposListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        presenter = ReposListPresenter(delegate: self)
        setupUI()
    }
    
    private func setupUI(){
        searchBar.delegate = self
        
        setupTableView()

    }
    
    private func setupTableView(){
        tableView.register(UINib(nibName: "RepoCell", bundle: nil), forCellReuseIdentifier: "RepoCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ReposListViewController: ReposPresenterDelegate{
    func searchFailed(error: NSError) {
        print("Error :: ", error.localizedDescription )
    }
    
    func searchSucces() {
        self.tableView.reloadData()
    }
    
    
}

extension ReposListViewController: UITableViewDelegate{
    
}

extension ReposListViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  presenter?.reposCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! RepoCell
        
        if let itemData = presenter?.getRepoData(at: indexPath.row){
            cell.nameLabel.text = itemData.name
            cell.stargazersCountLabel.text = itemData.stars
        }
        return cell
    }
}


extension ReposListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.serachRepos(queryString: searchText)

    }
}



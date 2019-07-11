//
//  ReposListPresenter.swift
//  MVVM_POC
//
//  Created by Moayad Al kouz on 7/10/19.
//  Copyright © 2019 Moayad Al kouz. All rights reserved.
//
import Foundation

protocol ReposListPresenterProtocol {
    func serachRepos(queryString: String)
    func getRepoData(at index: Int) -> (name: String, stars: String)
    var reposCount: Int { get }
}

protocol ReposPresenterDelegate: class{
    func searchFailed(error: NSError)
    func searchSucces()
}


class ReposListPresenter: ReposListPresenterProtocol {
    private var searchRepos: SearchReposResults?
    
    weak var delegate: ReposPresenterDelegate?
    
    init(delegate: ReposPresenterDelegate) {
        self.delegate = delegate
    }
    
    func serachRepos(queryString: String){
        if queryString.count < 3{
            let error = NSError(domain: "Error101", code: 101, userInfo:
                [
                    NSLocalizedDescriptionKey :  "Query string should be at least 3 chars" ,
                    NSLocalizedFailureReasonErrorKey : "Query string should be at least 3 chars"
                ]
            )
            delegate?.searchFailed(error: error)
            return
        }
        
        DataSource.shared.searchRepos(queryString: queryString) { [weak self] (results) in
            switch results{
            case .success(let model):
                self?.searchRepos = model
                self?.delegate?.searchSucces()

            case .failure(let error):
                self?.delegate?.searchFailed(error: error)

            }
        }
    }
    
    
    var reposCount: Int{
        return searchRepos?.reposItems?.count ?? 0
    }
    
    func getRepoData(at index: Int) -> (name: String, stars: String){
        guard let items = searchRepos?.reposItems, index >= 0, index < items.count else{
            return ("", "")
        }
        
        let item = items[index]
        
        return( item.name ?? "", String(format: "%d", item.stars ?? 0))
    }
}

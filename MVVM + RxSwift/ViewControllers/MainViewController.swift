//
//  ViewController.swift
//  MVVM + RxSwift
//
//  Created by Артём Харченко on 20.10.2022.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    private var viewModel = ViewModel()
    
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        tableView.rowHeight = 80
        viewModel.fetchUsers()
        bindTableView()
    }
    
    func setUpNavBar() {
        title = "List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(onTapAdd)
        )
        
        navigationController?.navigationBar.tintColor = .red
    }
    
    @objc func onTapAdd() {
        let user = User(id: 2, userId: 1, title: "Новая заметка", body: "hello")
        self.viewModel.addUser(user: user)
    }
    
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag) //?? delegate, rx, bind
        viewModel.users.bind(to: tableView.rx.items( //??
            cellIdentifier: "cell",
            cellType: UITableViewCell.self)) { (row, item, cell) in
                cell.textLabel?.text = item.title
                cell.detailTextLabel?.text = "\(item.id)"
            }.disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print(indexPath.row)
            //алерт
            
        }).disposed(by: bag)
        
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.deleteUser(index: indexPath.row)
        }).disposed(by: bag)
        
    }

}

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
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: view.frame, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel = MainViewControllerViewModel()
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchUsers()
        view.addSubview(tableView)
        setUpNavBar()
        bindTableView()
        setupRefreshControll()
    }
    
    func setUpNavBar() {
        title = "List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navigationController?.navigationBar.tintColor = .red
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
    }
    
    @objc func addNewTask() { //доработать
        let user = User(id: 1, name: "Bob", email: "bob@ya.ru", phone: "7777777777")
        self.viewModel.addUser(user: user)
    }
    
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag) //?? delegate, rx, bind
    
        viewModel.users.bind(to: tableView.rx.items(
            cellIdentifier: "cell",
            cellType: UITableViewCell.self)) { (row, item, cell) in
                cell.textLabel?.text = item.name
                cell.detailTextLabel?.text = "\(item.id)"
            }.disposed(by: bag)
        
        //itemSelected
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let alert = UIAlertController(
                title: "Note",
                message: "Edit Note",
                preferredStyle: .alert
            )
            
            alert.addTextField { textField in
                textField.placeholder = "Task"
                //получить достпу к строчке??
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                let textField = alert.textFields![0] as UITextField
                self.viewModel.editUser(title: textField.text ?? "", index: indexPath.row)
            }))
            
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }).disposed(by: bag)
        
        //itemDeleted
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.deleteUser(index: indexPath.row)
        }).disposed(by: bag)
        
    }
    
    func setupRefreshControll() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl?.addTarget(self, action: #selector(downloadData), for: .valueChanged)
    }
    
    @objc func downloadData() {
        viewModel.fetchUsers()
        if tableView.refreshControl != nil {
            tableView.refreshControl?.endRefreshing()
        }
        tableView.reloadData()
    }

}

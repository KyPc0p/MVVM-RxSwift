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
        viewModel.fetchUsers()
        bindTableView()
    }
    
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag)
        viewModel.users.bind(to: tableView.rx.items(
            cellIdentifier: "cell",
            cellType: UITableViewCell.self)) { (row, item, cell) in
                cell.textLabel?.text = item.title
                cell.detailTextLabel?.text = "\(item.id)"
            
            }.disposed(by: bag)
    }

}

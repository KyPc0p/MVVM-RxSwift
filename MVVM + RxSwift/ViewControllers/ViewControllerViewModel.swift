//
//  ViewControllerViewModel.swift
//  MVVM + RxSwift
//
//  Created by Артём Харченко on 20.10.2022.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    var users = BehaviorSubject(value: [User]())
    
    func fetchUsers() {
        NetworkManager.shared.fetchData([User].self, from: Links.url.rawValue) { result in
            switch result {
            case.success(let user):
                self.users.on(.next(user)) //уведомили всех подписчиков об ивенте
            case.failure(let error):
                print(error)
            }
        }
    }
    
}

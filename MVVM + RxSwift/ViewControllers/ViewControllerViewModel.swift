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
    
    func addUser(user: User) {
        guard var users = try? users.value() else { return }
        users.insert(user, at: 0)
        self.users.on(.next(users))
    }
    
    func deleteUser(index: Int) {
        guard var users = try? users.value() else { return }
        users.remove(at: index)
        self.users.on(.next(users))
    }
    
    func editUser(title: String, index: Int) {
        guard var users = try? users.value() else { return }
        users[index].title = title
        self.users.on(.next(users))
    }
    
}

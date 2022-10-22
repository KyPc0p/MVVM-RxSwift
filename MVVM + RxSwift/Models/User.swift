//
//  User.swift
//  MVVM + RxSwift
//
//  Created by Артём Харченко on 20.10.2022.
//

import Foundation

struct User: Decodable {
    let id: Int
    var name: String
    let email, phone: String
}

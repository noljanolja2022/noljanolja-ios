//
//  HomeModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation

struct ProfileModel: Decodable {
    let email: String?
    let id: String
    let isEmailVerified: Bool?
    let name: String?
    let phone: String?
    let profileImage: String?
    let pushNotiEnabled: Bool?
    let pushToken: String?

    var isSetup: Bool {
        !name.unwrapped(or: "").isEmpty
    }
}

//
//  HomeModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation

struct ProfileModel: Decodable {
    let id: String
    let name: String?
    let profileImage: String?
    let pushToken: String?
    let pushNotiEnabled: Bool?
    let phone: String?
    let email: String?
    let isEmailVerified: Bool?
}

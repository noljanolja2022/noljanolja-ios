//
//  ConversationModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//

import Foundation

struct ConversationModel: Decodable {
    let id = UUID()
    let avatar: String?
    let name: String?
    let lastMessage: String?
}

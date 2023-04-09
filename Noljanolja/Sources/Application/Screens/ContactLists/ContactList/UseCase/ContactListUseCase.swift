//
//  ContactListUseCase.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//

import Combine
import Foundation

protocol ContactListUseCase {
    func getContacts(page: Int, pageSize: Int) -> AnyPublisher<[User], Error>
}

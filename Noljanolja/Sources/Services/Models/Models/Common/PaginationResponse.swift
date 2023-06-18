//
//  PaginationResponse.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/06/2023.
//

import Foundation

// MARK: - Pagination

struct Pagination: Decodable {
    let page: Int
    let pageSize: Int
    let total: Int

    enum CodingKeys: CodingKey {
        case page
        case pageSize
        case total
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int.self, forKey: .page)
        self.pageSize = try container.decode(Int.self, forKey: .pageSize)
        self.total = try container.decode(Int.self, forKey: .total)
    }
}

// MARK: - PaginationResponse

struct PaginationResponse<Model: Decodable>: Decodable {
    let data: Model
    let pagination: Pagination

    enum CodingKeys: CodingKey {
        case data
        case pagination
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode(Model.self, forKey: .data)
        self.pagination = try container.decode(Pagination.self, forKey: .pagination)
    }
}

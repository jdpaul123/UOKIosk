//
//  File.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/6/23.
//

import Foundation

struct WhatIsOpenDto: Decodable {
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case pagination = "pagination"
    }
    let type: String
    let pagination: Pagination
}

struct Pagination: Decodable {
    let page: Int
    let pageCount: Int
}

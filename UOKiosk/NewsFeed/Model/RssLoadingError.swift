//
//  RssError.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 7/20/23.
//

import Foundation

enum RssArticleLoadingError : Error {
    case dataTaskFailed(Error)
    case networkingError(Error)
    case requestFailed(Int)
    case serverError(Int)
    case notFound
    case feedParsingError(Error)
    case missingAttribute(String)
    case recievedJsonError
    case recievedAtomError
    case shouldNeverOccurError
}

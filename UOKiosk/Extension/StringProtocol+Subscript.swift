//
//  StringProtocol+Subscript.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/8/23.
//

import Foundation

// First used in WhatIsOpenService's getAssetData(url: String) method
// https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift
extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
}

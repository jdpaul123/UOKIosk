//
//  Array+SafeSubscript.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/8/23.
//

import Foundation

// First used in WhatIsOpenService's getAssetData(url: String) method
// https://www.hackingwithswift.com/example-code/language/how-to-make-array-access-safer-using-a-custom-subscript
extension Array {
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }

        return self[index]
    }
}

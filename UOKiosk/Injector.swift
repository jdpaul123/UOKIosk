//
//  Dependency.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/8/22.
//

import SwiftUI

class Injector: ObservableObject {
    /*
     Location of instantiation for all dependency creation for the program
     */
    
    //static let shared: Injector = Injector()
    
    @Published var events: [Event]
    
    init() {
        self.events = [] // Will later be filled with events when needed
    }
}



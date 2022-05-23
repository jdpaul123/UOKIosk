//
//  UOKioskApp.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 4/15/22.
//

import SwiftUI

@main
struct UOKioskApp: App {
    @State var injector = Injector()
    
    var body: some Scene {
        WindowGroup {
            TabOptionsView(injector: injector)
        }
    }
}

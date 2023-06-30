//
//  RadioView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/29/23.
//

import SwiftUI

struct RadioView: View {
    @StateObject var vm: RadioViewModel
    @State var hasAppeared = false

    init(vm: RadioViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        VStack {
            Text("KWVA will stream from here")
            Button(vm.playPauseString) {
                vm.playPause()
            }
        }
        .onAppear {
            if !hasAppeared {
                vm.onViewAppearFirstTime()
                hasAppeared = true
            }
        }
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        RadioView(vm: RadioViewModel())
    }
}

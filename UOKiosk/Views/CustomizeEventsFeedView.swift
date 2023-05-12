//
//  CustomizeEventsFeedView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/12/23.
//
import SwiftUI

struct CustomizeEventsFeedView: View {
    let vm: CustomizeEventsFeedViewModel

    var body: some View {
        VStack {
            Text("HI")
        }
    }
}

#if DEBUG
struct CustomizeEventsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizeEventsFeedView(vm: CustomizeEventsFeedViewModel())
    }
}
#endif

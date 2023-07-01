//
//  RadioView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/29/23.
//

import SwiftUI

struct RadioView: View {
    @StateObject var vm: RadioViewModel

    init(vm: RadioViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        List {
            VStack {
                HStack {
                    Spacer()
                    Image("KWVA")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(7)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(Color.white, lineWidth: 5)
                                )
                        .padding()
                        .frame(maxWidth: 400)
                    Spacer()
                }
                Button {
                    vm.playOrStop()
                } label: {
                    Spacer()
                    vm.playOrStopImage
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    Spacer()
                }
                .buttonStyle(BorderlessButtonStyle())
            }

        }
        .onAppear {
            vm.swiftUIViewDidLoad()
        }
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        RadioView(vm: RadioViewModel())
    }
}

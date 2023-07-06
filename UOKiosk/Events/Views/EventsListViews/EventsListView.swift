//
//  EventsListView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/15/23.
//
// Helpful link for figuring out how to get images to ignore padding: https://stackoverflow.com/questions/56614080/how-to-remove-the-left-and-right-padding-of-a-list-in-swiftui/58210994#58210994

import SwiftUI

struct EventsListView: View {
    @EnvironmentObject var injector: Injector
    @StateObject var vm: EventsListViewModel

    // MARK: INITIALIZER
    init(vm: EventsListViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        List {
            ForEach(vm.eventsDictionary.keys, id: \.description) { dateToDisplay in
                EventsListSectionView(vm: injector.viewModelFactory.makeEventsListSectionViewModel(parentViewModel: self.vm, dateToDisplay: dateToDisplay))
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
            }
        }
        .overlay {
            if vm.showLoading {
                ProgressView()
                    .scaleEffect(2)
            }
        }
        .task {
            if vm.viewModelHasLoaded { return }
            if vm.isLoading { return }
            await vm.fetchEvents()
        }
        .banner(data: $vm.bannerData, show: $vm.showBanner)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    vm.showingInformationSheet.toggle()
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .sheet(isPresented: $vm.showingInformationSheet) { InformationView() }
    }
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        let injector = Injector()
        NavigationView {
            EventsListView(vm: injector.viewModelFactory.makeEventsListViewModel())
                .environmentObject(injector)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

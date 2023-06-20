//
//  EventDetailView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/17/22.
//

import SwiftUI

struct EventDetailView: View {
    @State var firstAppear = true
    @StateObject var vm: EventDetailViewModel
    @State private var showingCalendarSheet = false

    // Banner values for the case that the reminder was successfully created
    @State var successfullyCreatedReminderBannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "Success", detail: "Reminder was created!", type: .Success)
    @State var reminderCreated = false

    // Banner values for teh case that the reminder failed to be created
    @State var failedToCreateReminderBannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "Failed", detail: "Failed to create reminder", type: .Error)
    @State var reminderFailed = false

    init(vm: EventDetailViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        ScrollView {
            VStack {
                Text("\(vm.title)")
                    .font(.title)
                VStack {
                    Image(uiImage: .init(data: vm.imageData)!)
                        .resizable()
                        .scaledToFit()
                        .padding()
                    if vm.hasLocation {
                        HStack {
                            Text("Location")
                                .bold()
                                .font(.title3)
                            Spacer()
                            VStack {
                                Text(vm.location)
                                    .font(.title3)
                                    .multilineTextAlignment(.center)
                                Text(vm.roomNumber)
                                    .font(.subheadline)
                            }
                        }
                        .padding()
                    }

                    HStack {
                        Text("Time")
                            .bold()
                            .font(.title3)
                        Spacer()
                        VStack {
                            Text(vm.dateRange)
                                .font(.title3)
                            Text(vm.timeRange)
                                .font(.subheadline)
                        }
                    }
                    .padding()
                }
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.UOKioskContentBackgroundColor))

                // Start Calendar/Reminder Buttons
                HStack {
                    Spacer()
                    Button {
                        showingCalendarSheet.toggle()
                    } label: {
                        VStack {
                            Image(systemName: "calendar")
                            Text("Add to Calendar")
                        }
                    }

                    Spacer()

                    Button {
                        if !reminderCreated, vm.hasAbilityToAddReminder {
                            if vm.tryAddReminder() {
                                reminderCreated = true
                            } else {
                                reminderFailed = true
                            }
                        }
                    } label: {
                        VStack {
                            Image(systemName: "bell")
                            Text("Set Reminder")
                        }
                    }
                    Spacer()
                }
                .sheet(isPresented: $showingCalendarSheet) {
                    EventKitView(eventTitle: vm.title, eventDescription: vm.eventDescription, eventAllDay: vm.event.allDay, eventStart: vm.event.start, eventEnd: vm.event.end)
                }
                .padding()
                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                // End Calendar/Reminder Buttons

                Text(vm.eventDescription)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.UOKioskContentBackgroundColor))
                if let website = vm.website {
                    Link("\(Image.init(systemName: "link.circle")) View Event Online", destination: website)
                        .padding()
                }
            }
            .padding()
        }
        .banner(data: $successfullyCreatedReminderBannerData, show: $reminderCreated)
        .banner(data: $failedToCreateReminderBannerData, show: $reminderFailed)
        .onAppear {
            if firstAppear {
                firstAppear.toggle()
                vm.prepareReminderStore()
            }
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.UOKioskBackgroundColor)
    }
}

#if DEBUG
//struct EventDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let event = MockEventsModelData().event
//        EventDetailView(event, injector: Injector(eventsRepository: MockEventsService(), whatIsOpenRepository: MockWhatIsOpenService()))
//    }
//}
#endif

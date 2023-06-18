//
//  EventDetailView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/17/22.
//

import SwiftUI

struct EventDetailView: View {
    @StateObject var vm: EventDetailViewModel

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

                HStack {
                    Spacer()
                    Button {
                        // TODO: Insert action to add the Event to calendar
                    } label: {
                        VStack {
                            Image(systemName: "calendar")
                            Text("Add to Calendar")
                        }
                    }

                    Spacer()

                    Button {
                        // TODO: Insert action to set reminder for the Event
                    } label: {
                        VStack {
                            Image(systemName: "bell")
                            Text("Set Reminder")
                        }
                    }
                    Spacer()
                }
                .padding()
                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))

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

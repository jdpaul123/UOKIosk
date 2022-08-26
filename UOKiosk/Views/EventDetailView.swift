//
//  EventDetailView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 8/17/22.
//

import SwiftUI

struct EventDetailView: View {
    let injector: Injector
    @StateObject var viewModel: EventDetailViewModel
    
    init(_ event: Event, injector: Injector) {
        _viewModel = StateObject(wrappedValue: injector.viewModelFactory.makeEventDetailViewModel(eventModel: event))
        self.injector = injector
    }

    var body: some View {
        ScrollView {
            VStack {
                Text("\(viewModel.title)")
                    .font(.title)
                VStack {
                    Image.init(uiImage: viewModel.image)
                        .resizable()
                        .scaledToFit()
                        .padding()
                    if viewModel.hasLocation {
                        HStack {
                            Text("Location")
                                .bold()
                                .font(.title3)
                            Spacer()
                            VStack {
                                Text(viewModel.location)
                                    .font(.title3)
                                    .multilineTextAlignment(.center)
                                Text(viewModel.roomNumber)
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
                            Text(viewModel.dateRange)
                                .font(.title3)
                            Text(viewModel.timeRange)
                                .font(.subheadline)

                        }
                    }
                    .padding()
                }
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.UOKioskContentBackgroundColor))
                
                HStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        VStack {
                            Image(systemName: "calendar")
                            Text("Add to Calendar")
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        
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
                
                Text(viewModel.eventDescription)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.UOKioskContentBackgroundColor))
                if let website = viewModel.website {
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
//        EventDetailView(EventsModelExampleData().eventsModel.events[0], injector: Injector(eventsRepository: MockEventsService()))
//    }
//}
#endif

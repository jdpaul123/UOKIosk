//
//  EventDetailView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 5/8/22.
//

/*
 TODO Use disclosure group for store hours times to expand to show hours
 */

import SwiftUI

struct EventDetailView: View {
    @Environment(\.openURL) var openURL
    
    let event: Event
    
    // TODO add colors to injector. Create a UIInjector that contains all the UI values to use throughout the app.
    let systemBackgroundColor = Color.init(uiColor: .systemGroupedBackground)
    let contentBackgroundColor = Color.init(uiColor: .secondarySystemGroupedBackground)
    
    var body: some View {
        ScrollView {
            VStack {
                Text("\(event.title)")
                    .font(.title)
                VStack {
                    Image.init(uiImage: event.image ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .padding()
                    HStack {
                        Text("Location")
                            .bold()
                            .font(.title3)
                        Spacer()
                        VStack {
                            Text(event.locationName)
                                .font(.title3)
                                .multilineTextAlignment(.center)
                            Text(event.roomNumber)
                                .font(.subheadline)
                        }
                        /*
                         TODO check if the event has already started. If so, dispable the add to calendar and set reminder buttons and put in a message that says the events
                         already started
                         TODO check if the event has a zoom link, if so replace the location with an option to copy the link or join the zoom link
                         */
                    }
                    .padding()
                    HStack {
                        Text("Time")
                            .bold()
                            .font(.title3)
                        Spacer()
                        VStack {
                            Text(event.getDateRange())
                                .font(.title3)
                            Text(event.getTimeRange())
                                .font(.subheadline)

                        }
                    }
                    .padding()
                }
                .background(RoundedRectangle(cornerRadius: 10).fill(contentBackgroundColor))
                
                HStack {
                    Spacer()
                    Button {
                        if let icsURL = event.icsURL {
                            openURL(icsURL)
                        }
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
                
                Text(event.description)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(contentBackgroundColor))
                Link("\(Image.init(systemName: "link.circle")) View Event Online", destination: event.eventURL!)
                    .padding()
            }
            .padding()
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(systemBackgroundColor)
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EventDetailView(event: Event.sampleEventData[0])
        }
    }
}

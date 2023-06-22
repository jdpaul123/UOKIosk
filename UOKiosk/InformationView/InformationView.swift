//
//  InformationView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/22/23.
//

import SwiftUI

struct InformationView: View {
    var body: some View {
        NavigationView {
            List {
                Link(destination: URL(string: "https://www.youtube.com")!) {
                    HStack {
                        Image(systemName: "star.fill")
                            .padding(EdgeInsets(top: 4, leading: 2, bottom: 4, trailing: 2))
                            .background(.yellow)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        Text("Rate UO Kiosk")
                    }
                }
                Link(destination: URL(string: "https://www.youtube.com")!) {
                    HStack {
                        Image(systemName: "exclamationmark.bubble.fill")
                            .padding(EdgeInsets(top: 4, leading: 2, bottom: 4, trailing: 2))
                            .background(.purple)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        Text("Give Feedback")
                    }
                }
                Section("Emergency") {
                    Link(destination: URL(string: "tel:911")!) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .padding(EdgeInsets(top: 4, leading: 2, bottom: 4, trailing: 2))
                                .background(.red)
                                .foregroundColor(.white)
                                .cornerRadius(4)
                            Text("Emergency Call 911")
                        }
                    }
                    NavigationLink("Non-Emergency Click Here") {
                        List {
                            Section(header: Text("On Campus"), footer: Text("On campus non-emergency assistance and information")) {
                                Link("Call UOPD", destination: URL(string: "tel:5413462919")!)
                            }
                            Section(header: Text("Off Campus"), footer: Text("Off campus, for non-emergencies or to report past crimes.")) {
                                Link("Call Eugene PD", destination: URL(string: "tel:5416825111")!)
                                Link("Call Springfield PD", destination: URL(string: "tel:5417263714")!)
                            }
                            Section(header: Text("After-Hours Support & Crisis Line"), footer: Text("Call any time to speak with a therapist who can provide support and connect you with resources")) {
                                Link("Call Counseling Center", destination: URL(string: "tel:5413463227")!)
                            }
                        }
                    }
                }
                Section("Useful stuff") {
                    NavigationLink {
                        QuickLinksView()
                    } label: {
                        HStack {
                            Image(systemName: "link")
                                .padding(EdgeInsets(top: 4, leading: 2, bottom: 4, trailing: 2))
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(4)
                            Text("Quick Links")
                        }
                    }
                    NavigationLink {
                        Text("UO Rides")
                    } label: {
                        HStack {
                            Image(systemName: "car")
                                .padding(EdgeInsets(top: 4, leading: 2, bottom: 4, trailing: 2))
                                .background(.green)
                                .foregroundColor(.white)
                                .cornerRadius(4)
                            Text("UO Rides")
                        }
                    }
                    NavigationLink {
                        Text("Academic Calendar")
                    } label: {
                        HStack {
                            Image(systemName: "calendar")
                                .padding(EdgeInsets(top: 4, leading: 2, bottom: 4, trailing: 2))
                                .background(.cyan)
                                .foregroundColor(.white)
                                .cornerRadius(4)
                            Text("Academic Calendar")
                        }
                    }
                }
                Text("Made with 💚 by JD Paul. Sco Ducks!")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct QuickLinksView: View {
    var body: some View {
        Text("HELLO")
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}

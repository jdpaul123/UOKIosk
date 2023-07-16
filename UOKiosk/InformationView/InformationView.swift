//
//  InformationView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/22/23.
//

import SwiftUI

struct InformationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State var showJDAndDuck: Bool = false

    var body: some View {
        NavigationView {
            List {
                // TODO: Fill in the Rate UO Kiosk Link
//                Link(destination: URL(string: "https://www.youtube.com")!) {
//                    getImageAndText(systemName: "star.fill", text: "Rate UO Kiosk", color: .yellow)
//                }
                Link(destination: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSe14al43HKbvc1226qG6E5-1Cf-7hpobVhUFP19ZJtPvKINyA/viewform?usp=sf_link")!) {
                    getImageAndText(systemName: "exclamationmark.bubble.fill", text: "Give Feedback", color: .purple)
                }
                Section("Emergency") {
                    Link(destination: URL(string: "tel:911")!) {
                        getImageAndText(systemName: "exclamationmark.triangle", text: "Emergency Call 911", color: .red)
                    }
                    NavigationLink("Non-Emergency Click Here") {
                        List {
                            Section(header: Text("On Campus"), footer: Text("On campus non-emergency assistance and information.")) {
                                Link("Call UOPD", destination: URL(string: "tel:5413462919")!)
                            }
                            Section(header: Text("Off Campus"), footer: Text("Off campus, for non-emergencies or to report past crimes.")) {
                                Link("Call Eugene PD", destination: URL(string: "tel:5416825111")!)
                                Link("Call Springfield PD", destination: URL(string: "tel:5417263714")!)
                            }
                            Section(header: Text("After-Hours Support & Crisis Line"), footer: Text("Call any time to speak with a therapist who can provide support and connect you with resources.")) {
                                Link("Call Counseling Center", destination: URL(string: "tel:5413463227")!)
                            }
                        }
                        .navigationTitle("Non-Emergency")
                    }
                }
                Section(content: {
                    NavigationLink {
                        QuickLinksView()
                            .navigationTitle("Quick Links")
                    } label: {
                        getImageAndText(systemName: "link", text: "Quick Links", color: .blue)
                    }
                    NavigationLink {
                        TransportationLinksView()
                            .navigationTitle("Transportation Links")
                    } label: {
                        getImageAndText(systemName: "car", text: "Transportation Links", color: .green)
                    }
                    // TODO: Impliment the Academic Calendar View
//                    NavigationLink {
//                        Text("Academic Calendar")
//                    } label: {
//                        getImageAndText(systemName: "calendar", text: "Academic Calendar", color: .cyan)
//                    }
                }, header: {
                    Text("Useful stuff")
                }, footer: {
                    HStack {
                        Spacer()
                        (Text("Made with 💚 by ") +
                        Text("JD Paul ")
                            .foregroundColor(.blue) +

                        Text("- Sco Ducks!"))
                            .gesture(TapGesture(count: 1).onEnded {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showJDAndDuck.toggle()
                                }
                            })
                        Spacer()
                    }
                    .padding()
                })
                if showJDAndDuck {
                    VStack(alignment: .leading) {
                        let height: CGFloat = 40
                        Link(destination: URL(string: "https://jonathandpaul.com")!) {
                            HStack {
                                Text("jonathandpaul.com ")
                                Spacer()
                                Image(systemName: "globe")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: height)
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle()) // Makes just the button clickable rather than the entire row
                        Link(destination: URL(string: "https://www.instagram.com/jd_paul7/")!) {
                            HStack {
                                Text("JD's Instagram ")
                                Spacer()
                                Image("instagramIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: height)
                                    .cornerRadius(11)
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle()) // Makes just the button clickable rather than the entire row

                        Link(destination: URL(string: "https://www.linkedin.com/in/jdpaul123/")!) {
                            HStack {
                                Text("JD's LinkedIn ")
                                Spacer()
                                Image("linkedInIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: height)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle()) // Makes just the button clickable rather than the entire row
                        Image("JDAndDuck")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("UO Kiosk")
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func getImageAndText(systemName: String, text: String, color: Color) -> some View {
        return HStack {
            Image(systemName: systemName)
                .padding(EdgeInsets(top: 4, leading: 2, bottom: 4, trailing: 2))
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(4)
            Text(text)
        }
    }
}

struct QuickLinksView: View {
    var body: some View {
        List {
            Link("One Stop Student Resources", destination: URL(string: "https://onestop.uoregon.edu/")!)
            Link("University of Oregon's YouTube Channel", destination: URL(string: "https://www.youtube.com/channel/UCrRdNuHLBSGjZEoby4d5gmw")!)
            Section("Academic") {
                Link("Duck Web", destination: URL(string: "http://duckweb.uoregon.edu/pls/prod/twbkwbis.P_WWWLogin")!)
                Link("Canvas", destination: URL(string: "https://canvas.uoregon.edu/")!)
                Link("Webmail", destination: URL(string: "https://webmail.uoregon.edu/")!)
                Link("UOmail", destination: URL(string: "https://uomail.uoregon.edu/")!)
            }
            Section("Health") {
                Link("myUOHealth Portal", destination: URL(string: "https://uoregon.medicatconnect.com/Shibboleth.sso/Login?entityID=https%3A%2F%2Fshibboleth.uoregon.edu%2Fidp%2Fshibboleth")!)
            }
            Section("Campus Facilities") {
                Link("Starrez Housing Portal", destination: URL(string: "https://oregon.starrezhousing.com/StarRezPortalX/1219965E/7/140/Login-Log_In/")!)
                Link("Add Duck Bucks", destination: URL(string: "https://emu.uoregon.edu/duck-bucks/online-services/")!)
            }
        }
    }
}

struct TransportationLinksView: View {
    var body: some View {
        List {
            Link("Duck Rides", destination: URL(string: "https://transportation.uoregon.edu/duck-rides/")!)
            Link("Superpedestrian E-Scooters", destination: URL(string: "https://apps.apple.com/us/app/superpedestrian-link-scooters/id1487864428/")!)
            Link("E-Bike Lending Library", destination: URL(string: "https://transportation.uoregon.edu/e-bike/")!)
            Link("PeaceHealth Rides", destination: URL(string: "https://transportation.uoregon.edu/peacehealth-rides/")!)
            Link("Lyft Discounted Rides", destination: URL(string: "https://transportation.uoregon.edu/uo-lyft-night-rides/")!)
            Link("Umo Bus App", destination: URL(string: "https://transportation.uoregon.edu/bus/")!)
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}

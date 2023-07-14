//
//  WhatIsOpenIssueReportingView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 7/13/23.
//

import SwiftUI

struct WhatIsOpenIssueReportingView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Image(systemName: "clock.badge.exclamationmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75)
                        .foregroundColor(.purple)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    Text("Report any issues with \"What's Open\" hours at the link below")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
//                    Text("""
//                         To ensure accurate information about the hours of various places in our app, we greatly appreciate your help in reporting any discrepancies. On-campus hours may vary from term to term and unexpected closures can occur. If you come across any data that seems incorrect in the "What's Open" tab, please follow the instructions below:
//                         """)
                    Text("""
                         1. Click on the form link provided below to access the reporting form.
                         2. Specify the details of the incorrect information you have noticed.
                         """)
                    .font(.body)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                    Text("""
                         • If the discrepancy relates to temporary hours, such as during holidays or special events, please include the specific dates and provide the correct hours for those periods.
                         • If you notice consistently incorrect hours on specific days of the week, kindly mention those days and provide the accurate hours for each of them.
                         """)
                    .font(.body)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    Text("Thank you for your assistance in keeping the app's data accurate!")
                        .font(.body)
                        .bold()
                        .padding()
                        .multilineTextAlignment(.center)
                }
                Spacer()
                Link(destination: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSe14al43HKbvc1226qG6E5-1Cf-7hpobVhUFP19ZJtPvKINyA/viewform?usp=sf_link")!) {
                    HStack {
                        Image(systemName: "exclamationmark.bubble.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                            .foregroundColor(.white)
                        Text("Send Feedback")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .frame(maxWidth: .infinity)
                    .background(.purple)
                    .cornerRadius(10)
                }
            }
            .padding()
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct WhatIsOpenIssueReportingView_Previews: PreviewProvider {
    static var previews: some View {
        WhatIsOpenIssueReportingView()
    }
}

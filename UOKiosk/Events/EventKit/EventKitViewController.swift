//
//  EventKitViewController.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/18/23.
//
import SwiftUI
import EventKitUI

/*
 Helpful Videos:
 https://www.youtube.com/watch?v=qKAlsts4qFA -> Wrapping a UIViewController in a SwiftUI view by Paul Hudson
 https://www.youtube.com/watch?v=-a7q-q7zKCg -> Using coordinators to manage SwifttUI view controllers by Paul Hudson
 https://www.youtube.com/watch?v=ycn-K9kRu9M -> Events & Calendars in Swift 5 (EventKit, iOS, Swift 5, Xcode 12) - 2022 iOS Development by iOS Academy
 */
struct EventKitView: UIViewControllerRepresentable {
//    typealias UIViewControllerType = EKEventEditViewController
    // All UIViewControllers ultamately come from NSObject. NSObject allwos objective-c code to interface with Swift.
    class Coordinator: NSObject, UINavigationControllerDelegate, EKEventEditViewDelegate {
        var parent: EventKitView

        init(_ parent: EventKitView) {
            self.parent = parent
        }

        // MARK: - EKEventEditViewDelegate
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            controller.dismiss(animated: true)
            switch action {
            case .canceled:
                print("Event canceled")
            case .deleted:
                print("Event deleted")
            case .saved:
                do {
                    try parent.eventStore.save(parent.event, span: .thisEvent)
                    parent.eventCreated = true
                    print("Event saved to Calendar!")
                } catch {
                    print("FAILED TO SAVE EVENT WITH ERROR: \(error.localizedDescription)")
                }
            @unknown default:
                print("Unknown action number: \(action.rawValue) occured")
            }
        }
    }

    @State var eventCreated: Bool = false
    var eventStore = EKEventStore()

    // Event attributes
    let eventTitle: String
    let eventDescription: String
    let eventAllDay: Bool
    let eventStart: Date
    let eventEnd: Date?
    var event: EKEvent

    init(eventTitle: String, eventDescription: String, eventAllDay: Bool, eventStart: Date, eventEnd: Date?) {
        self.eventTitle = eventTitle
        self.eventDescription = eventDescription
        self.eventAllDay = eventAllDay
        self.eventStart = eventStart
        self.eventEnd = eventEnd

        eventStore.requestAccess(to: .event) { success, error in
            guard error == nil else {
                print("ERROR REQUESTING ACCESS TO ADD AN EVENT with error: \(String(describing: error?.localizedDescription))")
                return
            }
            guard success == true else {
                print("FAILED TO GET ACCESS TO ADD AN EVENT WITH NO ERROR")
                return
            }
            print("SUCCESS REQUESTING ACCESS TO ADD AN EVENT")
        }
        event = EKEvent(eventStore: eventStore)
    }

    func makeUIViewController(context: Context) -> EKEventEditViewController {
        event.title = eventTitle
        event.notes = eventDescription
        if eventAllDay {
            event.isAllDay = eventAllDay
        }
        event.startDate = eventStart
        if let end = eventEnd {
            event.endDate = end
        }

        let vc = EKEventEditViewController()
        // makeCoordinator() is called before makeUIViewController() and the context contains the Coordinator from makeCoordinator()
        // The coordinator will get any action reported to it.
        // Without any code inside of Coordinator, Xcode knows that the Cordinaor cannot be the coordinator for EKEventEditViewController until it inherets the correct protocol
        vc.delegate = context.coordinator
        vc.editViewDelegate = context.coordinator
        vc.eventStore = eventStore
        vc.event = event
        return vc
    }

    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Brandon Hill on 8/24/26.
//

import SwiftUI
import SwiftData
import CodeScanner
import UserNotifications

enum FilterType {
    case none, contacted, uncontacted
}

enum SortOrder {
    case name, recent
}

struct ProspectsView: View {
    let filter: FilterType
    @State private var sortOrder = SortOrder.name
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<Prospect>()
    @Environment(\.modelContext) var modelContext

    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "Uncontacted people"
        }
    }

    var body: some View {
        NavigationStack {
            ProspectsListView(filter: filter, sort: sortOrder, selectedProspects: $selectedProspects)
                .navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Scan", systemImage: "qrcode.viewfinder") {
                            isShowingScanner = true
                        }
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("Sort Order", selection: $sortOrder) {
                                Text("Sort by Name").tag(SortOrder.name)
                                Text("Sort by Most Recent").tag(SortOrder.recent)
                            }
                        }
                    }

                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }

                    if selectedProspects.isEmpty == false {
                        ToolbarItem(placement: .bottomBar) {
                            Button("Delete Selected", role: .destructive, action: deleteSelected)
                        }
                    }
                }
                .sheet(isPresented: $isShowingScanner) {
                    Text("Scanner View Here")
                }
        }
    }

    func deleteSelected() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }
}

// Private subview to re-evaluate @Query when sortOrder or filter changes
private struct ProspectsListView: View {
    @Query var prospects: [Prospect]
    @Binding var selectedProspects: Set<Prospect>
    @Environment(\.modelContext) var modelContext

    init(filter: FilterType, sort: SortOrder, selectedProspects: Binding<Set<Prospect>>) {
        self._selectedProspects = selectedProspects

        let showContactedOnly = filter == .contacted
        let isFilterNone = filter == .none

        let predicate = #Predicate<Prospect> { prospect in
            if isFilterNone {
                return true
            } else {
                return prospect.isContacted == showContactedOnly
            }
        }

        let sortDescriptor: SortDescriptor<Prospect> = switch sort {
        case .name:
            SortDescriptor(\Prospect.name)
        case .recent:
            SortDescriptor(\Prospect.createdAt, order: .reverse)
        }

        _prospects = Query(filter: predicate, sort: [sortDescriptor])
    }

    var body: some View {
        List(prospects, selection: $selectedProspects) { prospect in
            NavigationLink(destination: EditProspectView(prospect: prospect)) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    if prospect.isContacted {
                        Image(systemName: "person.crop.circle.fill.badge.checkmark")
                            .foregroundStyle(.green)
                    }
                }
            }
            .swipeActions {
                Button("Delete", systemImage: "trash", role: .destructive) {
                    modelContext.delete(prospect)
                }

                if prospect.isContacted {
                    Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                        prospect.isContacted.toggle()
                    }
                    .tint(.blue)
                } else {
                    Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                        prospect.isContacted.toggle()
                    }
                    .tint(.green)

                    Button("Remind Me", systemImage: "bell") {
                        addNotification(for: prospect)
                    }
                    .tint(.orange)
                }
            }
            .tag(prospect)
        }
    }

    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }

        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

struct EditProspectView: View {
    @Bindable var prospect: Prospect

    var body: some View {
        Form {
            TextField("Name", text: $prospect.name)
            TextField("Email Address", text: $prospect.emailAddress)
        }
        .navigationTitle("Edit Prospect")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Prospect.self, configurations: config)

    let sample1 = Prospect(name: "Paul Hudson", emailAddress: "paul@hackingwithswift.com", isContacted: false, createdAt: .now.addingTimeInterval(-3600))
    let sample2 = Prospect(name: "John Appleseed", emailAddress: "john@apple.com", isContacted: true, createdAt: .now.addingTimeInterval(-7200))
    let sample3 = Prospect(name: "Tim Cook", emailAddress: "tcook@apple.com", isContacted: false, createdAt: .now)

    container.mainContext.insert(sample1)
    container.mainContext.insert(sample2)
    container.mainContext.insert(sample3)

    return ProspectsView(filter: .none)
        .modelContainer(container)
}

//
//  ContentView.swift
//  TimeLog
//
//  Created by Eden Gottlieb on 02/06/2020.
//  Copyright © 2020 Eden Gottlieb. All rights reserved.
//

import SwiftUI

struct TimeEntry: Identifiable, Codable {
    var id: UUID = UUID()
    var time: Date
    var text: String
}

func loadEntries() -> Array<TimeEntry> {
    if let data = UserDefaults.standard.data(forKey: "TimeEntries") {
        if let decoded = try? JSONDecoder().decode([TimeEntry].self, from: data) {
            return decoded
        }
    }
    return [TimeEntry]()
}

struct ContentView: View {
    @ObservedObject private var keyboard = KeyboardResponder()
    @State private var entryText: String = ""
    @State private var time: String = ""
    @State private var entryDate = Date()
    @State private var times = loadEntries()
    

    func addEntry () {
        // Aspire to replace with #if os(macOS) (not working)
        #if targetEnvironment(macCatalyst)
            // This is called on macOS for some reason.
            let calculatedTime = getDateFormatter().date(from: self.time)
        #else
            let calculatedTime = self.entryDate
        #endif
        let timeEntry = TimeEntry(time: calculatedTime ?? Date() , text: self.entryText.trimmingCharacters(in: .whitespaces))
        self.times.insert(timeEntry, at: self.times.firstIndex(where: {$0.time > timeEntry.time}) ?? self.times.endIndex)
        self.entryDate = Date()
        self.time = ""
        self.entryText = ""
        save()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(times) {
            UserDefaults.standard.set(encoded, forKey: "TimeEntries")
        }
    }
    
    func delete(at offsets: IndexSet) {
        self.times.remove(atOffsets: offsets)
        save()
    }
    
    func removeAll() {
        self.times.removeAll()
        save()
    }
    
    func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }

    var body: some View {
        let dateFormatterPrint = getDateFormatter()
        let isActionDisabled = self.entryText.trimmingCharacters(in: .whitespaces).isEmpty;
        
        return NavigationView {
            VStack {
                       Spacer()
                       List {
                           ForEach(self.times) { entry in
                               HStack {
                                   Text(entry.text)
                                Spacer()
                                Text(dateFormatterPrint.string(from: entry.time))
                               }
                        }.onDelete(perform: delete)
                       }.navigationBarItems(leading: Button(action: self.removeAll) {
                           Text("Clear")
                       }, trailing: EditButton()).navigationBarTitle("Entries")
                #if targetEnvironment(macCatalyst)
                    TextField("Time", text: $time)
                #else
                        DatePicker(selection: $entryDate, displayedComponents: .hourAndMinute) {
                           Text("Select time")
                        }.labelsHidden()
                #endif
                TextField("Description", text: $entryText, onCommit: !isActionDisabled ? self.addEntry : {})
                       Button(action: self.addEntry) {
                        Text("Add Entry").frame(height: CGFloat(40)).padding(.bottom)
                       }.disabled(isActionDisabled)
                       
                   }
                   .padding(.bottom, keyboard.currentHeight)
                       .edgesIgnoringSafeArea(keyboard.currentHeight > 0 ? .bottom : .init()).animation(.easeOut(duration: 0.16))
               }
        }
           
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

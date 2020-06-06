//
//  ContentView.swift
//  TimeLog
//
//  Created by Eden Gottlieb on 02/06/2020.
//  Copyright © 2020 Eden Gottlieb. All rights reserved.
//

import SwiftUI

struct TimeEntry: Identifiable {
    var id: UUID = UUID()
    var time: Date
    var text: String
}

struct ContentView: View {
    @ObservedObject private var keyboard = KeyboardResponder()
    @State private var entryText: String = ""
    @State private var entryDate = Date()
    @State private var times = [TimeEntry]()
    
    func addEntry () {
        let timeEntry = TimeEntry(time: self.entryDate, text: self.entryText.trimmingCharacters(in: .whitespaces))
        self.times.insert(timeEntry, at: self.times.firstIndex(where: {$0.time > timeEntry.time}) ?? self.times.endIndex)
        self.entryDate = Date()
        self.entryText = ""
    }
    
    func delete(at offsets: IndexSet) {
        self.times.remove(atOffsets: offsets)
    }
    
    func removeAll() {
        self.times.removeAll()
    }

    var body: some View {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm"
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
                       DatePicker(selection: $entryDate, in: ...Date(), displayedComponents: .hourAndMinute) {
                           Text("Select time")
                       }.labelsHidden()
                TextField("uMessage", text: $entryText, onCommit: !isActionDisabled ? self.addEntry : {})
                       Button(action: self.addEntry) {
                           Text("Add entry").frame(height: CGFloat(40)).padding(.bottom)
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

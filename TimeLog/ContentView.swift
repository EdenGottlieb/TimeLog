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
    @State private var textFieldInput: String = ""
    var strengths = ["Mild", "Medium", "Mature"]

    @State private var selectedStrength = "hmm"
    @State private var birth = Date()
    @State private var times = [TimeEntry]()
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    func addEntry () {
        let timeEntry = TimeEntry(time: self.birth, text: self.textFieldInput.trimmingCharacters(in: .whitespaces))
        self.times.insert(timeEntry, at: self.times.firstIndex(where: {$0.time > timeEntry.time}) ?? self.times.endIndex)
        self.birth = Date()
        self.textFieldInput = ""
    }
    
    func delete(at offsets: IndexSet) {
        self.times.remove(atOffsets: offsets)
    }

    var body: some View {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm"
        //let calendar = Calendar.current
        //let date = Date()
        //let date1 = calendar.date(byAdding: .minute, value: -1, to: date)
        //let date2 = calendar.date(byAdding: .minute, value: -2, to: date)
        //let dateString = dateFormatterPrint.string(from: date)
        //let date1String = dateFormatterPrint.string(from: date1!)
        //let date2String = dateFormatterPrint.string(from: date2!)
        
        //return VStack (alignment: .center) {

        let isActionDisabled = self.textFieldInput.trimmingCharacters(in: .whitespaces).isEmpty;
        return NavigationView {
            VStack {
                       Spacer()
                       List {
                           ForEach(self.times) { entry in
                               HStack {
                                   Text(entry.text)
                                   Text(dateFormatterPrint.string(from: entry.time))
                               }
                        }.onDelete(perform: delete)
                        }.navigationBarTitle("Entries")
                       DatePicker(selection: $birth, in: ...Date(), displayedComponents: .hourAndMinute) {
                           Text("Select time")
                       }.labelsHidden()
                TextField("uMessage", text: $textFieldInput, onCommit: !isActionDisabled ? self.addEntry : {})
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

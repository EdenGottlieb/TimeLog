//
//  ContentView.swift
//  TimeLog
//
//  Created by Eden Gottlieb on 02/06/2020.
//  Copyright © 2020 Eden Gottlieb. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var keyboard = KeyboardResponder()
    @State private var textFieldInput: String = ""

    var body: some View {
        VStack (alignment: .leading) {
            Spacer()
            Text(textFieldInput).animation(nil)
            TextField("uMessage", text: $textFieldInput)
        }.frame(maxWidth: .infinity)
        .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(keyboard.currentHeight > 0 ? .bottom : .init()).animation(.easeOut(duration: 0.16))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

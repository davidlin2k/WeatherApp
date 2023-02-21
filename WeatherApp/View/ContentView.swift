//
//  ContentView.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "door.left.hand.open")
                        .onTapGesture {
                            logout()
                        }
                }
                Spacer()
            }
        }
        .toolbar(.visible, for: .navigationBar)
        .padding()
    }
    
    func logout() {
        User.currentUser = nil
        dismiss()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

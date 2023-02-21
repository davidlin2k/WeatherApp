//
//  RegisterView.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State var showAlert = false
    
    var body: some View {
        VStack() {
            TextField("Username", text: $username)
                .textContentType(.username)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
                .padding()
                
            
            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
                .padding()
            
            Button {
                register()
            } label: {
                Text("Register")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            
            Button {
                dismiss()
            } label: {
                Text("Cancel")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .padding()
            
        }
    }
    
    func register() {
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

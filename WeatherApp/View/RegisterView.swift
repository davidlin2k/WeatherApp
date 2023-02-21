//
//  RegisterView.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var userService: SQLiteUserService
    
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Register Failed"), dismissButton: .default(Text("OK")))
        }
    }
    
    func register() {
        if username.count < 6 {
            showAlert = true
            return
        }
        
        if password.count < 6 {
            showAlert = true
            return
        }
        
        let success = userService.createUser(username: username.lowercased(), password: password)
        
        if success {
            dismiss()
        }
        else {
            showAlert = true
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

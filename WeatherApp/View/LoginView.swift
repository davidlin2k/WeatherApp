//
//  LoginView.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var launchStateManager: LaunchStateManager
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State var showAlert = false
    @State var showLoggedInView = false
    @State var showRegisterView = false
    
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
                login()
            } label: {
                Text("Login")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            
            Button {
                register()
            } label: {
                Text("Register")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .padding()
            
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Login Failed"), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showRegisterView) {
            RegisterView()
                .interactiveDismissDisabled()
        }
        .fullScreenCover(isPresented: $showLoggedInView) {
            ContentView()
        }
        .task {
            try? await Task.sleep(for: Duration.seconds(1))
            self.launchStateManager.dismiss()
        }
    }
    
    func login() {
        let user = User.findBy(username: username.lowercased())
        
        guard let actualUser = user else {
            showAlert = true
            return
        }
        
        if actualUser.authenticate(password: password) {
            username = ""
            password = ""
            
            showLoggedInView = true
            User.currentUser = actualUser
        }
        else {
            showAlert = true
        }
    }
    
    func register() {
        showRegisterView = true
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

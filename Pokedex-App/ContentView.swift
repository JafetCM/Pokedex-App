//
//  ContentView.swift
//  Pokedex-App
//
//  Created by Monassi on 25/11/21.
//

import SwiftUI
import UIKit
import FirebaseAuth

class AppViewModel: ObservableObject {
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool{
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password:String){
        auth.signIn(withEmail: email,
                    password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                // Success
                self?.signedIn = true
            }
            
        }
    }
    
    func signUp(email: String, password:String){
        auth.createUser(withEmail: email,
                        password: password) {[weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                // Success
                self?.signedIn = true
            }
            
        }
    }
    
    func signOut(){
        try? auth.signOut()
        
        self.signedIn = false
    }
    
}

struct ContentView: View {
    
    @State var name = ""
    @State var lastname = ""
    @State var phone = ""
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationView{
            if viewModel.signedIn {
                VStack {
                    Text("You are signed in")
                    
                    Button(action: {
                        viewModel.signOut()
                    }, label: {
                        Text("Sign Out")
                            .frame(width: 200, height: 50)
                            .background(Color.red)
                            .foregroundColor(Color.white)
                            .padding()
                    })

                }
            }
            else{
                SignInView()
            }
        }
        .onAppear{
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}

struct SignInView: View {
    
    @State var name = ""
    @State var lastname = ""
    @State var phone = ""
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            Image("Logo")
            .resizable()
            .scaledToFit()
            .frame(width:150, height: 150)
            
            VStack{
                TextField("Correo", text:$email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                SecureField("Password", text:$password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    
                    viewModel.signIn(email: email, password: password)
                    
                }, label: {Text("Inciar")
                        .foregroundColor(Color.white)
                        .frame(width:200, height: 50)
                        .cornerRadius(8)
                        .background(Color.blue)
                    
                })
                
                NavigationLink("Create Account", destination: SignUpView())
                    .padding()
                
            }
            .padding()
            
            Spacer()
        }
    }
}

struct SignUpView: View {
    
    @State var name = ""
    @State var lastname = ""
    @State var phone = ""
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            Image("Logo")
            .resizable()
            .scaledToFit()
            .frame(width:150, height: 100)
            
            VStack{
                TextField("Nombre", text:$name)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .autocapitalization(/*@START_MENU_TOKEN@*/.words/*@END_MENU_TOKEN@*/)
                
                TextField("Apellido", text:$lastname)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .autocapitalization(.words)
                
                TextField("Celular", text:$phone)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .keyboardType(/*@START_MENU_TOKEN@*/.phonePad/*@END_MENU_TOKEN@*/)
                
                TextField("Correo", text:$email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                SecureField("Password", text:$password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    
                    viewModel.signUp(email: email, password: password)
                    
                }, label: {Text("Create Account")
                        .foregroundColor(Color.white)
                        .frame(width:200, height: 50)
                        .cornerRadius(8)
                        .background(Color.blue)
                    
                })
            }
            .padding()
            
            Spacer()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

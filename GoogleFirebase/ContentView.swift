//
//  ViewController.swift
//  GoogleAuthFirebase
//
//  Created by Maxim Macari on 05/10/2020.
//

import SwiftUI
import Firebase
import GoogleSignIn


struct ContentView: View{
    
    @State var user = Auth.auth().currentUser
    
    var body: some View {
        
        //updating view based on user login
        VStack{
            if user != nil {
                Home()
            } else{
                OnBoard()
            }
            
        }.onAppear(){
            NotificationCenter.default.addObserver(forName: NSNotification.Name("SINGIN"), object: nil, queue: .main) { (_) in
                //updating user..
                self.user = Auth.auth().currentUser
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct OnBoard: View {
    
    @State var onBoard = [
        Board(title: "Data Analysis", detail: "Data analysis is a process of inspecting, cleansing, transforming and modeling data with the goal of discovering useful information, informing conclusions and supporting decision-making.", pic: "b1"),
        
        Board(title: "Social Media", detail: "Social media are interactive computer-mediated technologies that facilitate the creation or sharing of information, ideas, career interests and other forms of expression via virtual communities and networks.", pic: "b2"),
        
        Board(title: "Software Development", detail: "Software development is the process of conceiving, specifying, designing, programming, documenting, testing, and bug fixing involved in creating and maintaining applications, frameworks, or other software components.", pic: "b3"),
        
    ]
    
    @State var index = 0
    
    var body: some View {
        VStack{
            Image(self.onBoard[self.index].pic)
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
            
            //Pages
            
            HStack(spacing: 12){
                ForEach(0..<self.onBoard.count, id: \.self){i in
                    
                    Circle()
                        .fill(self.index == i ? Color.gray : Color.black.opacity(0.07))
                        .frame(width: 10, height: 10)
                }
                
            }
            .padding(.top, 30)
            
            Text(self.onBoard[self.index].title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 35)
            
            Text(self.onBoard[self.index].detail)
                .foregroundColor(.black)
                .padding(.all, 15)
            
            Spacer(minLength: 0)
            
            Button(action: {
                //Update index
                
                if self.index < self.onBoard.count - 1 {
                    self.index += 1
                }else{
                    //Gogole Sign in..
                    
                    //Calling...
                    
                    GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
                    
                    GIDSignIn.sharedInstance()?.signIn()
                    
                }
                
                
                
            }){
                HStack{
                    
                    //Changing text when last screen appears
                    if self.index == self.onBoard.count - 1 {
                        Image("google")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                        
                    }
                    
                    Text(self.index == self.onBoard.count - 1 ? "Login" : "Next")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    
                }
                .padding(.all, 20)
                .frame(width: UIScreen.main.bounds.width - 200)
                .background(Color.red)
                .clipShape(Capsule())
                .padding(.bottom, 20)
                
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
    }
}


//Main Home View

struct Home: View {
    var body: some View{
        VStack{
            
            Spacer()
            VStack{
                Text("Logged in As \n \(Auth.auth().currentUser!.email!)")
                Text("Name:  \(Auth.auth().currentUser!.displayName!)")
                Text("Email verified:  \(Auth.auth().currentUser!.isEmailVerified == true ? "Yes" : "No")")
                if let phone = Auth.auth().currentUser!.phoneNumber {
                    Text("Phone number: \(phone)")
                }else{
                    Text("Phone number: Missing.")
                }
                Text("PhotoURL:  \(Auth.auth().currentUser!.photoURL!)")
                Text("Metadata:  \(Auth.auth().currentUser!.metadata)")
                Text("Is anonymous:  \(Auth.auth().currentUser!.isAnonymous == true ? "Yes" : "No")")
                
            }
            .multilineTextAlignment(.center)
            Spacer()
            
            Button(action: {
                
                logOut()
            }){
                Text("LogOut")
                    .foregroundColor(.white)
                    .padding(.all, 20)
                    .frame(width: UIScreen.main.bounds.width - 200)
                    .background(Color.red)
                    .clipShape(Capsule())
                    .padding(.bottom, 20)
                
            }        }
    }
    func logOut(){
        
        //Log out from google
        GIDSignIn.sharedInstance()?.signOut()
        
        //Log out from firebase
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}

struct Board {
    var title: String
    var detail: String
    var pic: String
}



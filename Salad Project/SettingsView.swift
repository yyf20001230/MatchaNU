//
//  SettingsView.swift
//  Salad Project
//
//  Created by Kevin Su on 27/8/2021.
//

//Settings page
import SwiftUI


struct SettingsView: View {
    
    @State var locationOn = true
    
    @State var height = CGFloat(UIScreen.main.bounds.height)
    @State var width =  CGFloat(UIScreen.main.bounds.width)
    @State var MainTab = CGSize.zero
    @State var ShowClass = false
    @State var `class` = ""
    @EnvironmentObject var settings: appSettings
    @State private var darkMode = false
    var body: some View {
        
        
        
        VStack{
            
           
            
            HStack{
                Button(action:{settings.Settings.toggle()}){
                    HStack(spacing: 2.0){
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    
                }
                Spacer()
                
            }
            .padding(.leading, 15)
            List{
                
                
                Toggle("Toggle Dark Mode", isOn: $darkMode)
                    .onChange(of: darkMode) {value in
                        if (darkMode == true){
                            settings.currentSystemScheme = .dark
                        }
                        else{
                            settings.currentSystemScheme = .light
                        }
                        
                        
                    }
                
                
                NavigationLink(destination: AboutView()){
                    Text("About this app")
                }
                NavigationLink(destination: BugView()){
                    Text("Report Bugs")
                }
                
            }
        
            
            
        }
        
        
        
        
        
        
        
        
        
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

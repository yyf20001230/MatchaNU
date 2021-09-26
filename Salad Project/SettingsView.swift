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
//            HStack{
//                Button(action:{settings.Settings.toggle()}){
//                    HStack(spacing: 2.0){
//                        Image(systemName: "arrow.left")
//                        Text("Back")
//                    }
//
//                }
//                Spacer()
//
//            }
//            .padding(.leading, 15)
            Form{
                Toggle("Toggle Dark Mode", isOn: $darkMode)
                    .onChange(of: darkMode) {value in
                        if (darkMode == true){
                            settings.currentSystemScheme = .dark
                        }
                        else{
                            settings.currentSystemScheme = .light
                        }
                        
                        
                    }
                
                
                Button(action:{settings.About.toggle()}){
                    HStack{
                        Text("About this app")
                        Spacer()
                        Image(systemName: "arrow.right")
                            .opacity(/*@START_MENU_TOKEN@*/0.6/*@END_MENU_TOKEN@*/)
                    }
                }
                .foregroundColor(/*@START_MENU_TOKEN@*/Color("Default")/*@END_MENU_TOKEN@*/)
                
                
                Button(action:{settings.Bug.toggle()}){
                    HStack{
                        Text("Report Bugs")
                        Spacer()
                        Image(systemName: "arrow.right")
                            .opacity(/*@START_MENU_TOKEN@*/0.6/*@END_MENU_TOKEN@*/)
                    }
                    
                }
                .foregroundColor(/*@START_MENU_TOKEN@*/Color("Default")/*@END_MENU_TOKEN@*/)
                
                
            }.cornerRadius(8)
            
        
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

//
//  SettingsView.swift
//  Salad Project
//
//  Created by Kevin Su on 27/8/2021.
//

//Settings page
import SwiftUI

struct SettingsView: View {
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    @State var SettingTab = CGSize.zero
    @EnvironmentObject var settings: appSettings
    @EnvironmentObject var classes: ClassLocations
    @State private var showAlert = false
    
    
    var body: some View {
        
        
        VStack{
            
            Rectangle()
                .frame(width: 40, height: 4)
                .cornerRadius(2)
                .foregroundColor(Color("Theme"))
                .offset(y: 10)
            
            
            VStack(spacing: 16.0) {
                
                
                HStack{
                    Text("Notification in Advance")
                        .foregroundColor(Color("Default"))
                    Spacer()
                    Picker("Notification in Advance", selection: $settings.TimeInAdvance){
                        ForEach([10,20,30,40,50,60], id: \.self){
                            Text("\($0) mins")
                        }
                    }
                    .accentColor(Color("Theme"))
                    .pickerStyle(.menu)
                }
                .padding(.horizontal)
                .padding(.top)
                
                HStack{
                    Text("Load quarter data")
                        .foregroundColor(Color("Default"))
                    Spacer()
                    Picker("Load quarter data", selection: $classes.Quarter){
                        ForEach(["Spring 2022", "Winter 2022"], id: \.self){
                            Text("\($0)")
                        }
                    }
                    .accentColor(Color("Theme"))
                    .pickerStyle(.menu)
                    .alert(isPresented: $classes.showAlert){
                        Alert(title: Text("Caution"),
                              message: Text("You are about to load course from \(classes.Quarter). You must restart matcha upon a successful switch of course data."),
                              dismissButton: .destructive(Text("I understand"), action: {
                                classes.showAlert = false
                                exit(0)
                              })
                            )
                    }
                    
                }
                .padding(.horizontal)
                
                HStack{
                    Text("System Appearance")
                        .foregroundColor(Color("Default"))
                    Spacer()
                    Picker("System Appearance", selection: $settings.isDarkMode){
                        ForEach(["Automatic", "Light", "Dark"], id: \.self){
                            Text("\($0)")
                        }
                    }
                    .accentColor(Color("Theme"))
                    .pickerStyle(.menu)
                }
                .padding(.horizontal)
                
                Toggle(isOn: $settings.hidePastEvent){
                    Text("Hide past event")
                }
                .padding(.horizontal)
                
                Toggle(isOn: $settings.timeline){
                    Text("Display timeline")
                }
                .padding(.horizontal)
                
                
                Button(action:{
                    settings.About.toggle()
                    settings.Settings = false
                }){
                    HStack{
                        Text("About this app")
                            .foregroundColor(Color("Default"))
                        Spacer()
                        Image(systemName: "arrow.right")
                            .opacity(/*@START_MENU_TOKEN@*/0.6/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color("Theme"))
                    }
                }
                
                .padding(.horizontal)
                
                Button(action:{
                    settings.Bug.toggle()
                    settings.Settings = false
                }){
                    HStack{
                        Text("Send us feedback")
                            .foregroundColor(Color("Default"))
                        Spacer()
                        Image(systemName: "arrow.right")
                            .opacity(/*@START_MENU_TOKEN@*/0.6/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color("Theme"))
                    }
                    
                }
                .padding(.horizontal)
                .padding(.top, CGFloat(UIScreen.main.bounds.height) * 0.01)
                
                Button(action:{
                    showAlert = true
                }){
                    HStack{
                        Text("Clear Classes")
                            .foregroundColor(Color("Red"))
                        Spacer()
                        Image(systemName: "arrow.right")
                            .opacity(/*@START_MENU_TOKEN@*/0.6/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color("Theme"))
                    }
                    
                }
                .padding([.horizontal, .bottom])
                .padding(.top, CGFloat(UIScreen.main.bounds.height) * 0.01)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Warning"),
                        message: Text("You are about to clear your classes. Are you sure?"),
                        primaryButton: .destructive(Text("Yes"), action: {
                            classes.userClass.removeAll()
                        }),
                        secondaryButton: .default(Text("No"))
                    )
                }
                
                
            }
            .background(Color("ClassColor"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.all)
            
            
            Rectangle()
                .frame(height: 200)
                .foregroundColor(Color("SearchbarColor"))
            
        }
        .background(Color("SearchbarColor"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .offset(y: self.SettingTab.height)
        .gesture(
            DragGesture().onChanged { value in
                self.SettingTab = value.translation
                if value.translation.height < -40 && settings.Settings
                    || value.translation.height > 40 && !settings.Settings{
                    self.SettingTab = CGSize.zero
                }
            }
                .onEnded{ value in
                    if value.translation.height > 80{
                        settings.Settings = false
                    }
                    self.SettingTab = CGSize.zero
                    
                }
        )
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

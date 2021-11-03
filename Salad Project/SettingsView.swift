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
                
                if settings.Settings{
                    HStack{
                        Text("Notification in Advance")
                            .foregroundColor(Color("Default"))
                        Spacer()
                        Picker("\(settings.TimeInAdvance) mins", selection: $settings.TimeInAdvance){
                            ForEach([10,20,30,40,50,60], id: \.self){
                                Text("\($0) mins")
                            }
                        }
                        .accentColor(Color("Theme"))
                        .pickerStyle(.menu)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    
                    
                    
                    Toggle("Toggle Dark Mode", isOn: $settings.isDarkMode)
                        .onChange(of: settings.isDarkMode) {value in
                            if (settings.isDarkMode == true){
                                settings.currentSystemScheme = .dark
                                
                            }
                            else{
                                settings.currentSystemScheme = .light
                            }
                            
                            
                        }
                        .foregroundColor(Color("Default"))
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                    
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
                                .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                        }
                    }
                    
                    .padding(.horizontal)
                    
                    Button(action:{
                        settings.Bug.toggle()
                        settings.Settings = false
                    }){
                        HStack{
                            Text("Report Bugs")
                                .foregroundColor(Color("Default"))
                            Spacer()
                            Image(systemName: "arrow.right")
                                .opacity(/*@START_MENU_TOKEN@*/0.6/*@END_MENU_TOKEN@*/)
                                .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                        }
                        
                    }
                    .padding([.horizontal, .top])
                    
                    Button(action:{
                        self.showAlert = true
                    }){
                        HStack{
                            Text("Clear Classes")
                                .foregroundColor(Color("Red"))
                            Spacer()
                            Image(systemName: "arrow.right")
                                .opacity(/*@START_MENU_TOKEN@*/0.6/*@END_MENU_TOKEN@*/)
                                .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                        }
                        
                    }
                    .padding(.all)
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

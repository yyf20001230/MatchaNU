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
    @State var FormTab = CGSize.zero
    @EnvironmentObject var settings: appSettings
    @EnvironmentObject var classes: ClassLocations
    @State private var darkMode = false
    @State private var showAlert = false
    
    var body: some View {
        
        
        
        VStack{
            Rectangle()
                .frame(width: 40, height: 4)
                .cornerRadius(2)
                .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                .offset(y: 10)
            VStack(spacing: 8.0) {
                Toggle("Toggle Dark Mode", isOn: $darkMode)
                    .onChange(of: darkMode) {value in
                        if (darkMode == true){
                            settings.currentSystemScheme = .dark
                        }
                        else{
                            settings.currentSystemScheme = .light
                        }
                        
                        
                    }
                    .foregroundColor(Color("Default"))
                    .padding([.horizontal,.top])
                
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
                
                .padding([.horizontal,.top])
                
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
                    classes.userClass.removeAll()
                }){
                    HStack{
                        Text("Clear Classes")
                            .foregroundColor(Color("Default"))
                        Spacer()
                        Image(systemName: "arrow.right")
                            .opacity(/*@START_MENU_TOKEN@*/0.6/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                    }
                    
                }
                .padding(.all)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Class Cleared"), message: Text("Your classes has been cleared"), dismissButton: .default(Text("Got it!")))
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

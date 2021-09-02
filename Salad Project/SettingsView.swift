//
//  SettingsView.swift
//  Salad Project
//
//  Created by Kevin Su on 27/8/2021.
//

//Settings page
import SwiftUI

struct SettingsView: View {
    @State var darkMode = false
    @State var locationOn = true
    
    @State var height = CGFloat(UIScreen.main.bounds.height)
    @State var width =  CGFloat(UIScreen.main.bounds.width)
    @State var MainTab = CGSize.zero
    @State var ShowClass = false
    @State var `class` = ""
    
    @Binding var showSchedule: Bool
    @Binding var showSettings: Bool
    var body: some View {
        
            ZStack{
                NavigationView{
                VStack{
                    List{
                        Toggle(isOn: $darkMode, label: {
                            Text("Toggle Dark Mode")
                        })
                        
                    
                        Toggle(isOn: $locationOn, label: {
                            Text("Turn off location services")
                        })
                        
                        
                    
                        NavigationLink(destination: AboutView()){
                            Text("About this app")
                        }
                        NavigationLink(destination: BugView()){
                            Text("Report Bugs")
                        }.navigationBarTitle("App Settings")
                        }
                        
                              
                        
                    
                    
                    
                }
                
                
                
            }
            VStack{
                HStack {
                    Spacer()
                    SideButtonView(showSchedule: $showSchedule, showSettings: $showSettings)
                        .padding(.trailing)
                        
                }
                Spacer()
                
            }
        }
        
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSchedule: .constant(false), showSettings: .constant(false))
    }
}

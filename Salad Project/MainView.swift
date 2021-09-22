//
//  MainView.swift
//  ClassFinder
//
//  Created by Kevin Su on 29/8/2021.
//

import SwiftUI

class appSettings: ObservableObject{
    @Published var toggleDarkMode = false
    @Published var Schedule = false
    @Published var Settings = false
    
}

struct MainView: View {
    @StateObject var settings = appSettings()
    var body: some View {
        let classes = ClassLocations()
        
        if settings.toggleDarkMode{
            if settings.Settings{
                SettingsView()
                    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
                    .environmentObject(settings)
            }
            else if settings.Schedule{
                ScheduleView()
                    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
                    .environmentObject(settings)
            }
            else{
                ContentView()
                    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
                    .environmentObject(settings)
            }
        }
        else{
            if settings.Settings{
                SettingsView()
                    .preferredColorScheme(.light)
                    .environmentObject(settings)
            }
            else if settings.Schedule{
                ScheduleView()
                    .preferredColorScheme(.light)
                    .environmentObject(settings)
            }
            else{
                ContentView()
                    .preferredColorScheme(.light)
                    .environmentObject(settings)
            }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            
    }
}

//
//  MainView.swift
//  ClassFinder
//
//  Created by Kevin Su on 29/8/2021.
//

import SwiftUI

class appSettings: ObservableObject{
    @Published var toggleDarkMode: ColorScheme = .light
    @Published var Schedule = false
    @Published var Settings = false
}

struct MainView: View {
    @StateObject var settings = appSettings()
    
    var body: some View {
        let classes = ClassLocations()
        
       
        if settings.Settings{
        SettingsView()
            .preferredColorScheme(settings.toggleDarkMode)
            .environmentObject(settings)
        }
        else if settings.Schedule{
            ScheduleView()
                .preferredColorScheme(settings.toggleDarkMode)
                .environmentObject(settings)
        }
        else{
            ContentView()
                .preferredColorScheme(settings.toggleDarkMode)
                .environmentObject(settings)
        }
    
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            
    }
}

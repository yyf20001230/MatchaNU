//
//  MainView.swift
//  ClassFinder
//
//  Created by Kevin Su on 29/8/2021.
//

import SwiftUI


func schemeTransform(userInterfaceStyle:UIUserInterfaceStyle) -> ColorScheme {
    if userInterfaceStyle == .light {
        return .light
    }else if userInterfaceStyle == .dark {
        return .dark
    }
    return .light}

struct MainView: View {
    
    
    @StateObject var settings = appSettings()
    
    
    var body: some View {
        if settings.Settings{
            SettingsView()
                .preferredColorScheme(settings.currentSystemScheme)
                .environmentObject(settings)
        }
        else if settings.Schedule{
            ScheduleView()
                .preferredColorScheme(settings.currentSystemScheme)
                .environmentObject(settings)
        }
        else{
            ContentView()
                .preferredColorScheme(settings.currentSystemScheme)
                .environmentObject(settings)
        }
    
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            
    }
}

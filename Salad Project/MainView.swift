//
//  MainView.swift
//  ClassFinder
//
//  Created by Kevin Su on 29/8/2021.
//

import SwiftUI

struct MainView: View {
    @State var showSettings = false
    @State var showSchedule = false
    @State var darkMode = false
    var body: some View {
        let classes = ClassLocations()
        if darkMode{
            if showSettings{
                SettingsView(darkMode: $darkMode, showSchedule: $showSchedule, showSettings: $showSettings)
                    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
            }
            else if showSchedule{
                ScheduleView(showSchedule: $showSchedule, showSettings: $showSettings)
                    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
            }
            else{
                ContentView(classes: classes,showSchedule: $showSchedule, showSettings: $showSettings)
                    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
            }
        }
        else{
            if showSettings{
                SettingsView(darkMode: $darkMode, showSchedule: $showSchedule, showSettings: $showSettings)
                    .preferredColorScheme(.light)
            }
            else if showSchedule{
                ScheduleView(showSchedule: $showSchedule, showSettings: $showSettings)
                    .preferredColorScheme(.light)
            }
            else{
                ContentView(classes: classes,showSchedule: $showSchedule, showSettings: $showSettings)
                    .preferredColorScheme(.light)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

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
    var body: some View {
        
        if showSettings{
            SettingsView(showSchedule: $showSchedule, showSettings: $showSettings)
        }
        else if showSchedule{
            ScheduleView(showSchedule: $showSchedule, showSettings: $showSettings)
        }
        else{
            ContentView(showSchedule: $showSchedule, showSettings: $showSettings)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

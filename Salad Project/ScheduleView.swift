//
//  ScheduleView.swift
//  ClassFinder
//
//  Created by Kevin Su on 27/8/2021.
//

import SwiftUI

struct ScheduleView: View {
    @State var height = CGFloat(UIScreen.main.bounds.height)
    @State var width =  CGFloat(UIScreen.main.bounds.width)
    @State var MainTab = CGSize.zero
    @State var ShowClass = false
    @State var `class` = ""
    @EnvironmentObject var settings: appSettings
    var body: some View {
        
        VStack{
            Text("Schedule view will be coming soon! Press the schedule button on the top right to go back to map.")
                .padding(20)
                .foregroundColor(.white)
            Button(action:{settings.Schedule = false})
            {
                Text("Back")
            }
        }
        
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}

//
//  ScheduleView.swift
//  ClassFinder
//
//  Created by Kevin Su on 27/8/2021.
//

import SwiftUI

struct ScheduleView: View {
    
    @State var ShowClass = false
    @State var `class` = ""
    @EnvironmentObject var settings: appSettings
    var body: some View {
        
        VStack{
            Text("Schedule view will be coming soon!")
                .padding(20)
                .foregroundColor(.white)
            Button(action:{settings.Schedule = false})
            {
                Text("Back to map")
                    .padding(.all)
                    .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))    
            }
        }
        
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}

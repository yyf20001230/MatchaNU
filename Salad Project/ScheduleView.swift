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
    var body: some View {
        ZStack {
            VStack{
                HStack {
                    Spacer()
                    SideButtonView()
                        .padding(.trailing)
                        
                }
                Spacer()
                Text("Schedule view will be coming soon!")
                Spacer()
                
            }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}

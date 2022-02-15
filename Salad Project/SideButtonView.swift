//
//  SideButtonView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 8/25/21.
//

import SwiftUI
import MapKit

struct SideButtonView: View {
    @EnvironmentObject var classes: ClassLocations
    @EnvironmentObject var settings: appSettings

    var body: some View {
        
        
        VStack {
            Button(action: {
                settings.Schedule.toggle()
                classes.quickNavigate = false
            }) {
                Image(systemName: "map")
                    .padding(.bottom,8)
                    .foregroundColor(Color("Theme"))
            }
            
            Divider()
                .frame(width: 24.0)
                .background(Color.white)
            
            Button(action: {
                settings.Settings.toggle()
            }){
                Image(systemName: "gear")
                .padding(.top,8)
                .foregroundColor(Color("Theme"))
            }
            
        }
        .padding(.all,12)
        .background(Color("SearchbarColor"))
        .cornerRadius(8)
        .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 0.0 )
    }
}

struct SideButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SideButtonView()
                .preferredColorScheme(.light)
            SideButtonView()
                .preferredColorScheme(.dark)
        }
    }
}


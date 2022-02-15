//
//  UserClassView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 9/28/21.
//

import SwiftUI

struct ScheduleButtonView: View {
    
    @EnvironmentObject var settings: appSettings
    var body: some View {
        
        Image(systemName: settings.Schedule ? "map" : "calendar")
            .padding(.all,16)
            .background(Color("SearchbarColor"))
            .cornerRadius(8)
            .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
        
    }
}

struct UserClassView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleButtonView()
    }
}

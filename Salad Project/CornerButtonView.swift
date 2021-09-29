//
//  CornerButtonView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 8/26/21.
//

import SwiftUI

struct CornerButtonView: View {
    @EnvironmentObject var classes: ClassLocations

    var body: some View {

        Image(systemName: classes.showUserLocation ? "location.fill" : "location")
            
            .padding(.all,16)
            .background(Color("SearchbarColor"))
            .cornerRadius(8)
            .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
    }
}

struct CornerButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CornerButtonView()
    }
}

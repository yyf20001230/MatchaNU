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
    var body: some View {
        VStack {
            Image(systemName: "map")
                .padding(.bottom,8)
                .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
            Divider()
                .frame(width: 24.0)
                .background(Color.white)
                
            Image(systemName: "gear")
                .padding(.top,8)
                .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
        }
        .padding(.all,12)
        .background(Color("SearchbarColor"))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
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

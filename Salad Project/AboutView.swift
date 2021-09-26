//
//  AboutView.swift
//  Salad Project
//
//  Created by Kevin Su on 27/8/2021.
//

import SwiftUI

struct AboutView: View {
    @EnvironmentObject var settings: appSettings
    var body: some View {
        VStack{
            Text("Hello!")
                .font(.headline)
            Text("As last year's classes were mostly remote, most of us weren't able to go to lecture halls to take their classes. \n \nTo help people (re)familiarize themselves with the campus and to make sure they don't forget to take their classes, we built this app to help students easily find and navigate themselves to their classes. Hope you guys like it!\n\n\n\n")
            HStack{
                Text("Frank Yang")
                Spacer()
                Text("Kevin Su")
            }.padding()
            Button(action:{ settings.About.toggle()}){
                Text("Back")
            }
        }
        .padding(.horizontal, 20.0)
        
        
        
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

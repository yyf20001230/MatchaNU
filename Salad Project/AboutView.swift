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
        ZStack{
            VStack{
                Text("Hello!")
                    .font(.headline)
                    .foregroundColor(Color.white)
                Text("As last year's classes were mostly remote, most of us weren't able to go to lecture halls to take their classes. \n \nTo help people (re)familiarize themselves with the campus and to make sure they don't forget to take their classes, we built this app to help students easily find and navigate themselves to their classes. Hope you guys like it!\n\n\n\n")
                    .foregroundColor(Color.white)
                HStack{
                    Text("Frank Yang")
                        .foregroundColor(Color.white)
                    Spacer()
                    Text("Kevin Su")
                        .foregroundColor(Color.white)
                }.padding()
                
            }
            .padding(.horizontal, 20.0)
            VStack{
                HStack(spacing:0){
                    Button(action:{ settings.About.toggle()}){
                        Image(systemName: "arrow.left")
                        Text("Back to map")
                    }.foregroundColor((Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1))))
                        
                    Spacer()
                }.padding(.leading,20)
                    .padding(.top, 100)
                Spacer()
            }
        }
        
        
        
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}


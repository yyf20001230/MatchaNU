//
//  BugView.swift
//  ClassFinder
//
//  Created by Kevin Su on 27/8/2021.
//

import SwiftUI
import MessageUI

struct BugView: View {
    init(){
            UITableView.appearance().backgroundColor = .clear
        }
    
    @State var BugTab = CGSize.zero
    @EnvironmentObject var settings: appSettings
    @EnvironmentObject var classes: ClassLocations

    var body: some View {
        
        
        
        VStack{
            Rectangle()
                .frame(width: 40, height: 4)
                .cornerRadius(2)
                .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                .offset(y: 10)
            
            Text("Hi there! This is our first iteration of Matcha, we know a lot of things are not perfect yet. We still have a LOT of ideas in mind, and we welcome any feedback. To show our gratitude to comments, we will give out free Matcha boba teas (yes, we really love Matcha!) to the first 20 students who emailed us for suggestions! If you have a comment or even if you just want chat - please use the email below to reach out to us!")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
                .tracking(-0.5)
                .lineSpacing(16)
                .padding(.all)
                .background(Color("ClassColor"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.all)
            
            Button(action:{
                
            }){
                HStack{
                    Text("Contact Us")
                        .foregroundColor(Color("ClassColor"))
                }
                .padding(.all)
                .background(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.all)
            }
            
            Rectangle()
                .frame(height: 50)
                .foregroundColor(Color("SearchbarColor"))
            
            
        }
        .background(Color("SearchbarColor"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .offset(y: self.BugTab.height)
        .gesture(
            DragGesture().onChanged { value in
                self.BugTab = value.translation
                if value.translation.height < -40 && settings.Bug
                    || value.translation.height > 40 && !settings.Bug{
                    self.BugTab = CGSize.zero
                }
            }
            .onEnded{ value in
                if value.translation.height > 80{
                    settings.Bug = false
                }
                self.BugTab = CGSize.zero 
            }
        )
    }
}


struct BugView_Previews: PreviewProvider {
    static var previews: some View {
        BugView()
    }
}

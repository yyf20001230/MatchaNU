//
//  QuickNavigationWindow.swift
//  Salad Project
//
//  Created by Yunfan Yang on 10/29/21.
//

import SwiftUI

struct QuickNavigationWindow: View {
    
    @EnvironmentObject var classes: ClassLocations
    @EnvironmentObject var settings: appSettings
    @State var MainTab = CGSize.zero
    
    var body: some View {
        
        VStack{
            if !classes.quickNavigateclass.isEmpty{
                let message = classes.quickNavigateclass[0].Major.components(separatedBy: " ")[0] + " " + classes.quickNavigateclass[0].Class.components(separatedBy: " ")[0]
                Text("Your \(message + "-" + classes.quickNavigateclass[0].Section.components(separatedBy: " ")[0].replacingOccurrences(of: ":", with: "")) is coming up in \(classes.quickNavigateTime) minutes. Wish to navigate?")
                    .foregroundColor(.primary)
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .frame(width: CGFloat(UIScreen.main.bounds.width) / 1.5)
                    .padding(.all, 24)
            }
            HStack (spacing: 72){
                Button(action: {
                    classes.quickNavigate = false
                }){
                    Text("No")
                        .foregroundColor(Color("ClassColor"))
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .padding(.all)
                        .background(Color("Theme").opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                
                Button(action: {
                    classes.ShowClass = true
                    classes.detail = classes.quickNavigateclass
                    classes.showRoute = true
                    classes.quickNavigate = false
                    settings.Schedule = false
                }){
                   Text("Yes")
                        .foregroundColor(Color("ClassColor"))
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .padding(.all)
                        .background(Color("Theme").opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                

            }
        }
        .padding(.all)
        .background(Color("SearchbarColor"))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
        .offset(y: MainTab.height)
        .gesture(
            DragGesture().onChanged { value in
                MainTab = value.translation
                if value.translation.height <  -40{
                    MainTab = CGSize.zero
                }
            }
            .onEnded{ value in
                if value.translation.height > 120{
                    classes.quickNavigate = false
                }
                MainTab = CGSize.zero
            }
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0))
        
        
    }
}

struct QuickNavigationWindow_Previews: PreviewProvider {
    static var previews: some View {
        QuickNavigationWindow()
    }
}

//
//  DetailView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 9/22/21.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var classes: ClassLocations
    
    var body: some View {
        
        VStack{
            Text("Meeting Info")
                .padding(.all)
            
            HStack{
                Button(action: {
                    self.classes.showRoute = true
                }){
                    Text("Navigate")
                }
            }
            
            if !self.classes.detail.isEmpty{
                Text(self.classes.detail[0].ClassOverview)
                    .foregroundColor(.primary)
                    .font(.system(.caption2, design: .rounded))
                    .tracking(-0.5)
                    .padding(.all)
                    .foregroundColor(Color("ClassColor"))
            }
            
        }
        
    }
}



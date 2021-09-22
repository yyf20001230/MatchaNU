//
//  DetailView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 9/22/21.
//

import SwiftUI
import MapKit

struct DetailView: View {
    @EnvironmentObject var classes: ClassLocations
    
    var body: some View {
        
        VStack{
            HStack{
                Button(action: {
                    self.classes.showRoute = true
                }){
                    Text("Navigate")
                }
                
                Button(action: {
                    let classlocation = MKPointAnnotation()
                    classlocation.coordinate = CLLocationCoordinate2D(latitude: classes.detail[0].ClassLocation[0], longitude: classes.detail[0].ClassLocation[1])
                    classlocation.title = classes.detail[0].Major.components(separatedBy: " ")[0] + " " + classes.detail[0].Class.components(separatedBy: " ")[0] + "\n"
                    classlocation.subtitle = classes.detail[0].MeetingInfo + "\n\n"
                    self.classes.classlocations.append(classlocation)
                }){
                    Text("Add")
                }
            }
            
            Text("Meeting Info")
                .padding(.all)
            
            
            if !self.classes.detail.isEmpty{
                VStack{
                    Text(self.classes.detail[0].ClassOverview)
                        .foregroundColor(.primary)
                        .font(.system(.caption2, design: .rounded))
                        .tracking(-0.5)
                        .padding(.all)
                }
                .background(Color("ClassColor"))
                
                    
            }
            
        }
        
    }
}



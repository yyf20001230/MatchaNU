//
//  ClassView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 8/25/21.
//

import SwiftUI

struct ClassView: View {
    var schools: [School] = SchoolList.Schools
    
    var body: some View {
        VStack {
            HStack{
                Text("Schools")
                    .font(.caption2)
                    .fontWeight(.bold)
                    
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .foregroundColor(Color("TitleColor"))
                Spacer()
            }
            
            ScrollView (showsIndicators: false) {
                ForEach(schools, id: \.id) { school in
                    HStack {
                        Image(school.logoName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                            .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                            .padding(.leading)
                        
                        VStack(alignment: .leading, spacing: 6.0) {
                            Text(school.title)
                                .font(.system(.body, design: .rounded))
                                .fontWeight(.bold)
                                .tracking(-0.5)
                            Text(school.description)
                                .font(.system(.caption2, design: .rounded))
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                                .tracking(-0.5)
                        }
                        .padding(.all)
                        Spacer()
                        
                    }
                    .padding(.leading)
                }
                .background(Color("ClassColor"))
                .cornerRadius(12)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding(.horizontal)
            
            Rectangle()
                .frame(height: 120)
                .foregroundColor(Color("SearchbarColor"))
            
            
        }
    }
}

struct ClassView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ClassView().preferredColorScheme(.light)
            ClassView().preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        }
    }
}

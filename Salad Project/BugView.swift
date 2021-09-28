//
//  BugView.swift
//  ClassFinder
//
//  Created by Kevin Su on 27/8/2021.
//

import SwiftUI

struct BugView: View {
    @EnvironmentObject var settings: appSettings
    var body: some View {
        VStack{
            Text("Not Available yet. We are working hard on this!\n")
            Button(action:{settings.Bug = false})
            {
                Text("Back")
                    .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
            }
        }
    }
}

struct BugView_Previews: PreviewProvider {
    static var previews: some View {
        BugView()
    }
}

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
            Text("Not Available yet. We are working hard on this!")
            Button(action:{settings.Bug = false})
            {
                Text("Back")
            }
        }
    }
}

struct BugView_Previews: PreviewProvider {
    static var previews: some View {
        BugView()
    }
}

//
//  Salad_ProjectApp.swift
//  Salad Project
//
//  Created by Yunfan Yang on 8/25/21.
//

import SwiftUI
import Firebase

@main
struct Salad_ProjectApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            
            MainView()
                .preferredColorScheme(.light)
        }
    }
}

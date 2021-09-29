//
//  BugView.swift
//  ClassFinder
//
//  Created by Kevin Su on 27/8/2021.
//

import SwiftUI

struct BugView: View {
    @State private var errorMessage = ""
    @EnvironmentObject var settings: appSettings
    var body: some View {
        VStack{
//            Text("What bugs did you encounter?")
//                .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
//
//            TextField("This feature doesn't seem to work!",text: $errorMessage)
//                .padding(.horizontal)
//                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.869))
//                .multilineTextAlignment(.center)
//
//
//            Button(action:{submitError(error_message: errorMessage)}){
//                Text("Send error message")
//                    .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
//            }
            Text("Not Available yet. We are working hard on this!\n")
                .foregroundColor(.white)
        }
        VStack{
            HStack(spacing:0){
                Button(action:{ settings.Bug.toggle()
                    
                }){
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
func submitError(error_message: String) -> Void{
    
}
struct BugView_Previews: PreviewProvider {
    static var previews: some View {
        BugView()
    }
}

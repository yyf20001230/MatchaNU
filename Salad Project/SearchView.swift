//
//  TestView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 8/28/21.
//

import SwiftUI
import MapKit

struct ClassList: View{
    @Binding var txt: String
    @Binding var datas: [ClassInfo]
    @Binding var uniqueData: [ClassInfo]
    @State private var showAlert = false
    @EnvironmentObject var classes: ClassLocations
    var body: some View{
        
        if self.txt == ""{
            
            Text("Enter your class")
                .foregroundColor(.secondary)
                .font(.system(.body, design: .rounded))
                .fontWeight(.bold)
                .tracking(-0.5)
                .multilineTextAlignment(.center)
                
                
            }
            
        
        else{
            let elements = (self.txt.count < 7 && self.uniqueData.filter({($0.Major.lowercased().components(separatedBy: " ")[0] + " " + $0.Class.lowercased().components(separatedBy: " ")[0] + " " + $0.Class.lowercased().components(separatedBy: " ").dropFirst().joined(separator: " ")).replacingOccurrences(of:"_", with: " ").prefix(self.txt.count).contains(self.txt.lowercased().replacingOccurrences(of:"_", with: " "))}).count != 0)
            
            ?
            
            self.uniqueData.filter({($0.Major.lowercased().components(separatedBy: " ")[0] + " " + $0.Class.lowercased().components(separatedBy: " ")[0] + " " + $0.Class.lowercased().components(separatedBy: " ").dropFirst().joined(separator: " ")).replacingOccurrences(of:"_", with: " ").prefix(self.txt.count).contains(self.txt.lowercased().replacingOccurrences(of:"_", with: " "))})
            
            :
            
            self.uniqueData.filter({($0.Major.lowercased().components(separatedBy: " ")[0] + " " + $0.Class.lowercased().components(separatedBy: " ")[0] + " " + $0.Class.lowercased().components(separatedBy: " ").dropFirst().joined(separator: " ")).replacingOccurrences(of:"_", with: " ").contains(self.txt.lowercased().replacingOccurrences(of:"_", with: " "))})
                        
            if elements.count == 0{
                Text("No results")
                    .foregroundColor(.secondary)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.bold)
                    .tracking(-0.5)
                    .multilineTextAlignment(.center)
            }
            
            else if self.classes.Section.count == 0{
                VStack {
                    ScrollView(showsIndicators: false){
                        ForEach(elements.prefix(20)){ i in
                            Button(action:{
                                self.classes.Section = self.datas.filter({($0.Class + $0.Major).lowercased().contains(i.Class.lowercased() + i.Major.lowercased())})
                                
                            }) {
                                HStack {
                                        Image(i.School)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 25)
                                            .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                                            .padding(.leading)
                                            .padding(.leading)
                                        
                                        VStack(alignment: .leading, spacing: 6.0) {
                                            Text(i.Major.components(separatedBy: " ")[0] + " " + i.Class.components(separatedBy: " ")[0])
                                                .foregroundColor(Color("Default"))
                                                .font(.system(.body, design: .rounded))
                                                .fontWeight(.bold)
                                                .tracking(-0.5)
                                            
                                            Text(i.Class.components(separatedBy: " ").dropFirst().joined(separator: " "))
                                                .foregroundColor(.secondary)
                                                .font(.system(.caption2, design: .rounded))
                                                .tracking(-0.5)
                                            
                                        }
                                        .padding(.all)
                                        Spacer()
                                }
                            }
                        }
                        .background(Color("ClassColor"))
                        .cornerRadius(12)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(.horizontal)
                    
                    Rectangle()
                        .foregroundColor(Color("SearchbarColor"))
                        .frame(height: 120)
                }
                .ignoresSafeArea()
                
                
            } else {
                VStack{
                    ScrollView(showsIndicators: false){
                        ForEach(self.classes.Section){ i in
                            Button(action: {
                                self.classes.detail.removeAll()
                                self.classes.detail.append(i)
                                if i.ClassLocation[0] == -1 && i.ClassLocation[1] == -1{
                                    self.showAlert = true
                                }
                            })
                            {
                                HStack (spacing: 20.0){
                                    Text(i.Section.components(separatedBy: " ")[0].replacingOccurrences(of: ":", with: ""))
                                        .foregroundColor(Color("Default"))
                                        .font(.system(.body, design: .rounded))
                                        .fontWeight(.bold)
                                        .tracking(-0.5)
                                        .frame(width: 60)
                                        
                                    VStack(alignment: .leading, spacing: 4.0){
                                        Text(i.Instructor.dropLast())
                                            .foregroundColor(.secondary)
                                            .font(.system(.caption2, design: .rounded))
                                            .tracking(-0.5)
                                        Text(i.MeetingInfo.components(separatedBy: ": ")[0])
                                            .foregroundColor(.secondary)
                                            .font(.system(.caption2, design: .rounded))
                                            .tracking(-0.5)
                                        Text(i.MeetingInfo.components(separatedBy: ": ")[1])
                                            .foregroundColor(.secondary)
                                            .font(.system(.caption2, design: .rounded))
                                            .tracking(-0.5)
                                    }
                                }
                                .padding(.all)
                                Spacer()
                            }
                            
                            
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(.horizontal)
                    
                    Rectangle()
                        .foregroundColor(Color("SearchbarColor"))
                        .frame(height: 120)
                }
            }
            
        }
        
        
        
    }
}

class getClass: ObservableObject{

    @Published var data = [ClassInfo]()
    @Published var uniquedata = [ClassInfo]()
    
    init(){
        if let fileLocation = Bundle.main.url(forResource: "Matcha", withExtension: "json") {
            do {
                let classData = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let datafromJson = try jsonDecoder.decode([ClassInfo].self,from: classData)
                
                self.data = datafromJson
                for document in self.data{
                    if self.uniquedata.filter({($0.Class + $0.Major).contains(document.Class + document.Major)}).count == 0 {
                        self.uniquedata.append(document)
                    }
                }
            }
            catch {
                print(error)
            }
        }
    }
}


struct ClassInfo: Identifiable, Codable, Equatable{
    let id = UUID()
    var Class: String
    var ClassLocation: [Double]
    var ClassOverview: String
    var Instructor: String
    var Major: String
    var MeetingInfo: String
    var School: String
    var Section: String
}

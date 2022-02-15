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
    @Binding var uniqueProf: [ClassInfo]
    @EnvironmentObject var classes: ClassLocations
    //@State var offset = CGSize.zero
    
    var body: some View{
        
        if self.txt == ""{
            
            if classes.userClass.count == 0{
                Text("Keep Typing...")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                    .fontWeight(.bold)
                    .tracking(-0.5)
            }
            
            VStack (alignment: .leading){
                
                if classes.userClass.count != 0{
                    Text("\(classes.Quarter) class")
                        .foregroundColor(.secondary)
                        .fontWeight(.bold)
                        .font(.system(.subheadline, design: .rounded))
                        .tracking(-0.5)
                        .padding(.leading)
                }
               
                
                ScrollView(showsIndicators: false){
                    ForEach(classes.userClass){ i in
                        Button(action: {
                            classes.detail.removeAll()
                            classes.detail.append(i)
                        }){
                            VStack (alignment: .leading, spacing: 10){

                                HStack{
                                    let message = i.Major.components(separatedBy: " ")[0] + " " + i.Class.components(separatedBy: " ")[0]
                                    Text(message + "-" + i.Section.components(separatedBy: " ")[0].replacingOccurrences(of: ":", with: ""))
                                        .foregroundColor(Color("Default"))
                                        .font(.system(.subheadline, design: .rounded))
                                        .fontWeight(.bold)
                                        .tracking(-0.5)
                                        .multilineTextAlignment(.leading)
                                        .padding(.leading)
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    VStack(alignment: .leading, spacing: 4.0){
                                        Text(i.Instructor.replacingOccurrences(of: "|", with: ",").dropLast())
                                            .foregroundColor(.secondary)
                                            .font(.system(.caption, design: .rounded))
                                            .tracking(-0.5)
                                            .multilineTextAlignment(.leading)
                                        Text(i.MeetingInfo.contains(": ") ? i.MeetingInfo.components(separatedBy: ": ")[0] : "TBA")
                                            .foregroundColor(.secondary)
                                            .font(.system(.caption, design: .rounded))
                                            .tracking(-0.5)
                                            .multilineTextAlignment(.leading)
                                        Text(i.MeetingInfo.contains(": ") ? i.MeetingInfo.components(separatedBy: ": ")[1] : "TBA")
                                            .foregroundColor(.secondary)
                                            .font(.system(.caption, design: .rounded))
                                            .tracking(-0.5)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding(.leading)
                                    
                                    Spacer()
                                }
                                
                            }
                            .padding(.all)
                            
                        }
                        .background(Color("ClassColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        /*
                        .gesture(
                            DragGesture().onChanged{ value in
                                offset = value.translation
                            }
                        )
                        .offset(offset.x)
                         */
                        
                    }
                    
                }
                .padding(.horizontal)
                
                Rectangle()
                    .foregroundColor(Color("SearchbarColor"))
                    .frame(height: 120)
            }
            
            
        } else {
            
            let text = self.txt.lowercased().replacingOccurrences(of:"_", with: "")
            let elements = (text.count < 7 && self.uniqueData.filter({($0.Major.lowercased().components(separatedBy: " ")[0]).replacingOccurrences(of:"_", with: " ").replacingOccurrences(of:" ", with: "").prefix(self.txt.count).contains(text.replacingOccurrences(of:" ", with: ""))}).count != 0)
            
                ?
            
            self.uniqueData.filter({($0.Major.lowercased().components(separatedBy: " ")[0]).replacingOccurrences(of:"_", with: "").replacingOccurrences(of:" ", with: "").prefix(self.txt.count).contains(text.replacingOccurrences(of:" ", with: ""))})
            
                :
            
            self.uniqueData.filter({($0.Major.lowercased().components(separatedBy: " ")[0] + $0.Class.lowercased().components(separatedBy: " ")[0] + $0.Class.lowercased().components(separatedBy: " ").dropFirst().joined(separator: " ")).replacingOccurrences(of:"_", with: "").replacingOccurrences(of:" ", with: "").contains(text.replacingOccurrences(of:" ", with: ""))}) + self.uniqueProf.filter({($0.Instructor).lowercased().contains(text)})
            
            
            if elements.count == 0{
                if self.txt.replacingOccurrences(of: " ", with: "").count != 0{
                    Text("No results")
                        .foregroundColor(.secondary)
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.bold)
                        .tracking(-0.5)
                        .multilineTextAlignment(.leading)
                } else {
                    Text("Keep Typing...")
                        .foregroundColor(.secondary)
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.bold)
                        .tracking(-0.5)
                        .multilineTextAlignment(.leading)
                }
                
            }
            
            else if classes.Section.count == 0{
               ScrollView(showsIndicators: false){
                    ForEach(elements.prefix(12)){ i in
                        Button(action:{
                            classes.Section = datas.filter({($0.Class + $0.Major).lowercased().contains(i.Class.lowercased() + i.Major.lowercased())})
                            
                        }) {
                            HStack {
                                Image(i.School)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 25)
                                    .foregroundColor(Color("Theme"))
                                    .padding(.leading)
                                    .padding(.leading)
                                
                                VStack(alignment: .leading, spacing: 6.0) {
                                    Text(i.Major.components(separatedBy: " ")[0] + " " + i.Class.components(separatedBy: " ")[0])
                                        .foregroundColor(Color("Default"))
                                        .font(.system(.body, design: .rounded))
                                        .fontWeight(.bold)
                                        .tracking(-0.5)
                                        .multilineTextAlignment(.leading)
                                    
                                    Text(i.Class.components(separatedBy: " ").dropFirst().joined(separator: " "))
                                        .foregroundColor(.secondary)
                                        .font(.system(.caption, design: .rounded))
                                        .fontWeight(.semibold)
                                        .tracking(-0.5)
                                        .multilineTextAlignment(.leading)

                                    
                                }
                                .padding(.all)
                                Spacer()
                            }
                        }
                    }
                    .background(Color("ClassColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                }
                .padding(.horizontal)
                
                
                
                Rectangle()
                    .frame(height: 100)
                    .foregroundColor(Color("SearchbarColor"))
                
                
                
                
                
                
            } else {
                VStack{
                    ScrollView(showsIndicators: false){
                        ForEach(classes.Section){ i in
                            Button(action: {
                                classes.detail.removeAll()
                                classes.detail.append(i)
                                let startHour = separateHourMinute(scrapedString: scrapeStartHoursMinutes(rawString: classes.detail[0].MeetingInfo))[0]
                                let endHour = separateHourMinute(scrapedString: scrapeEndHoursMinutes(rawString: classes.detail[0].MeetingInfo))[0]
                                classes.startTime = startHour != -1 ? min(classes.startTime, startHour - 1) : classes.startTime
                                classes.endTime = endHour != -1 ? max(classes.endTime, endHour + 2) : classes.endTime
                                
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
                                        Text(i.Instructor.replacingOccurrences(of: "|", with: ",").dropLast())
                                            .foregroundColor(.secondary)
                                            .font(.system(.caption2, design: .rounded))
                                            .fontWeight(.semibold)
                                            .tracking(-0.5)
                                            .multilineTextAlignment(.leading)
                                        Text(i.MeetingInfo.contains(": ") ? i.MeetingInfo.components(separatedBy: ": ")[0] : "TBA")
                                            .foregroundColor(.secondary)
                                            .font(.system(.caption2, design: .rounded))
                                            .fontWeight(.semibold)
                                            .tracking(-0.5)
                                            .multilineTextAlignment(.leading)
                                        Text(i.MeetingInfo.contains(": ") ? i.MeetingInfo.components(separatedBy: ": ")[1] : "TBA")
                                            .foregroundColor(.secondary)
                                            .font(.system(.caption2, design: .rounded))
                                            .fontWeight(.semibold)
                                            .tracking(-0.5)
                                            .multilineTextAlignment(.leading)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.all)
                                .background(Color("ClassColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Rectangle()
                        .foregroundColor(Color("SearchbarColor"))
                        .frame(height: 120)
                }
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            
        }
        
        
        
    }
}

class getClass: ObservableObject{
    
    @Published var data = [ClassInfo]()
    @Published var uniquedata = [ClassInfo]()
    @Published var uniqueprof = [ClassInfo]()
    @Published var quarter = UserDefaults.standard.string(forKey: "Quarter") ?? "Spring 2022"
    
    init(){
        
        if let fileLocation = Bundle.main.url(forResource: quarter, withExtension: "json") {
            do {
                let classData = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let datafromJson = try jsonDecoder.decode([ClassInfo].self,from: classData)
                
                self.data = datafromJson
                for document in self.data{
                    if self.uniquedata.count == 0 || self.uniquedata.last!.Class + self.uniquedata.last!.Major != (document.Class + document.Major){
                        
                        self.uniquedata.append(document)
                        
                        
                    }
                    if self.uniqueprof.count == 0 || self.uniqueprof.last!.Instructor != (document.Instructor){
                        
                        self.uniqueprof.append(document)
                        
                    }
                    
                }
                
            }
            catch {
                print(error)
            }
        }
    }
}


struct ClassInfo: Identifiable, Codable, Equatable, Hashable{
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


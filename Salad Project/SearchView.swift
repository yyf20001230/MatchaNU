//
//  TestView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 8/28/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import MapKit

struct ClassList: View{
    @Binding var txt: String
    @Binding var datas: [Classes]
    @Binding var uniqueData: [Classes]
    @EnvironmentObject var classes: ClassLocations
    var encoder = CLGeocoder()

    
    var body: some View{

        if self.txt != "" {
            let elements = self.uniqueData.filter({($0.Major.lowercased().components(separatedBy: " ")[0] + " " + $0.Class.lowercased().components(separatedBy: " ")[0] + " " + $0.Class.lowercased().components(separatedBy: " ").dropFirst().joined(separator: " ")).replacingOccurrences(of:"_", with: " ").contains(self.txt.lowercased().replacingOccurrences(of:"_", with: " "))})
            
            
            if elements.count == 0{
                Text("No result found...")
                    .foregroundColor(Color("Default"))
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.bold)
                    .tracking(-0.5)
                    .padding()
                    
                    
            }
            else if elements.count > 20{
                Text("Keep Typing...")
                    .foregroundColor(.secondary)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.bold)
                    .tracking(-0.5)
                    
                    
            }else if self.classes.Section.count == 0{
                VStack {
                    ScrollView(showsIndicators: false){
                        ForEach(elements){ i in
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
                                encoder.geocodeAddressString("Tech"){ (placemarks, error) in
                                    guard
                                        let placemarks = placemarks,
                                        let location = placemarks.first?.location
                                    else {
                                        return
                                    }
                                    let classlocation = MKPointAnnotation()
                                    classlocation.coordinate = location.coordinate
                                    classlocation.title = i.Class
                                    classes.classlocations.append(classlocation)
                                }
                            }) {
                                HStack (spacing: 20.0){
                                    Text(i.Section.components(separatedBy: ":")[0])
                                        .foregroundColor(Color("Default"))
                                        .font(.system(.body, design: .rounded))
                                        .fontWeight(.bold)
                                        .tracking(-0.5)
                                        .padding(.trailing)
                                    
                                    VStack(alignment: .leading, spacing: 2.0){
                                        Text(i.Instructor + " | " + i.MeetingInfo.components(separatedBy: ": ")[0])
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
            
        } else {
            Text("Keep Typing...")
                .foregroundColor(.secondary)
                .font(.system(.body, design: .rounded))
                .fontWeight(.bold)
                .tracking(-0.5)
        }
        
        
        
    }
}

class getClass: ObservableObject{
    private var path = "classes"
    @Published var data = [Classes]()
    @Published var uniquedata = [Classes]()
    
    init(){
        let db = Firestore.firestore()
        
        db.collection(path).getDocuments{ (snapshot, error) in
            
            if error != nil{
                print((error?.localizedDescription)!)
                return
            }
            
            for i in snapshot!.documents{
                let id = i.documentID
                let Class = i.get("Class") as! String
                let ClassOverView = i.get("Class Overview") as! String
                let Instructor = i.get("Instructor") as! String
                let Major = i.get("Major") as! String
                let MeetingInfo = i.get("Meeting Info") as! String
                let School = i.get("School") as! String
                let Section = i.get("Section") as! String
                self.data.append(Classes(id: id, Class: Class, ClassOverView: ClassOverView, Instructor: Instructor, Major: Major, MeetingInfo: MeetingInfo, School: School, Section: Section))
                
                if self.uniquedata.filter({($0.Class + $0.Major).contains(Class + Major)}).count == 0{
                    self.uniquedata.append(Classes(id: id, Class: Class, ClassOverView: ClassOverView, Instructor: Instructor, Major: Major, MeetingInfo: MeetingInfo, School: School, Section: Section))
                }
            }
        }
    }
}





struct Classes: Identifiable, Equatable{
    @DocumentID var id: String?
    var Class: String
    var ClassOverView: String
    var Instructor: String
    var Major: String
    var MeetingInfo: String
    var School: String
    var Section: String
}

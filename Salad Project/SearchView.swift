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

struct CustomSearchView: View {
    @State var Class =  "COMP"
    @ObservedObject var data = getClass()
    
    var body: some View {
        NavigationView {
            ClassList(txt: self.$Class, datas: self.$data.data)
                    .padding(.all)
        }
        
    }
}

struct CustomSearchView_Previews: PreviewProvider {
    static var previews: some View {
        CustomSearchView()
    }
}

struct SearchBar: View{
    @State var txt = ""
    var body: some View{

        HStack {
            TextField("Add your class here", text: $txt)
            Spacer()
            if self.txt != ""{
                Button(action: {
                    self.txt = ""
                }){
                    Image(systemName: "xmark.circle.fill")
                        .padding(.trailing)
                }
                .foregroundColor((Color("Default").opacity(0.3)))
            } else{
                Image(systemName:"magnifyingglass")
                    .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                    .padding(.trailing)
            }
        }
        

    }
}


struct ClassList: View{
    @Binding var txt: String
    @Binding var datas: [Classes]
    @EnvironmentObject var classes: ClassLocations
    
    var body: some View{

        if self.txt != "" {
            if self.datas.filter({$0.name.lowercased().contains(self.txt.lowercased())}).count == 0{
                Text("No result found...")
                    .foregroundColor(Color("Default"))
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.bold)
                    .tracking(-0.5)
                    .padding()
                    
                    
            } else{
                VStack {
                    ScrollView(showsIndicators: false){
                        ForEach(self.datas.filter{$0.name.lowercased().contains(self.txt.lowercased())}){ i in
                            Button(action:{
                                if Int(i.location.latitude) != -1 && Int(i.location.longitude) != -1{
                                    let Point = MKPointAnnotation()
                                    Point.title = i.name
                                    Point.coordinate = CLLocationCoordinate2D(latitude: i.location.latitude, longitude: i.location.longitude)
                                    classes.classlocations.append(Point)
                                    print(getSection(documentID: i.id ?? "").count)
                                    print(i.id ?? "")
                                    
                                }
                                
                                //print TBA or remote if the course does not have a location
                                else{
                                    
                                }
                                
                            }) {
                                HStack {
                                        Image(i.major)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 25)
                                            .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                                            .padding(.leading)
                                        
                                        VStack(alignment: .leading, spacing: 6.0) {
                                            Text(i.name)
                                                .foregroundColor(Color("Default"))
                                                .font(.system(.body, design: .rounded))
                                                .fontWeight(.bold)
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
                
                
            }
            
            
        }
        
        
        
    }
}

class getClass: ObservableObject{
    private var path = "Classes"
    @Published var data = [Classes]()
    
    init(){
        let db = Firestore.firestore()
        
        db.collection(path).getDocuments{ (snapshot, error) in
            
            if error != nil{
                print((error?.localizedDescription)!)
                return
            }
            
            for i in snapshot!.documents{
                let id = i.documentID
                let name = i.get("name") as! String
                let number = i.get("number") as! Int
                let major = i.get("major") as! String
                let location = i.get("location") as! GeoPoint
                self.data.append(Classes(id: id, name: name, number: number, major: major, location: location))
            }
        }
    }
}

func getSection(documentID: String) -> [Section]{
    
    var sections = [Section]()
    
    let db = Firestore.firestore()
    
    db.collection("Classes").document(documentID).collection("Section").getDocuments{(snapshot, error) in
        
        if error != nil{
            print((error?.localizedDescription)!)
            return
        }
        
        for i in snapshot!.documents{
            let id = i.documentID
            let section = i.get("section") as! Int
            sections.append(Section(id: id, section: section))
            print(String(section))
            
        }
    }
    
    return sections
    
    
}





struct Classes: Identifiable{
    
    @DocumentID var id: String?
    var name: String
    var number: Int
    var major: String
    var location: GeoPoint
}

struct Section: Identifiable{
    
    @DocumentID var id: String?
    var section: Int
}


struct Detail: View {
    
    var data: Classes
    
    var body: some View{
        Text(String(data.number))
    }
}






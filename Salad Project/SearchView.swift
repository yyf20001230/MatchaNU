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
    @ObservedObject var data = getData()
    
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
    @Binding var datas: [DataType]
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
                            NavigationLink(destination: Detail(data: i)){
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
                    .onTapGesture{
                        let London = MKPointAnnotation()
                        London.title = "COMP_SCI 340"
                        London.coordinate = CLLocationCoordinate2D(latitude: 42.06, longitude: -87.65)
                        classes.classlocations.append(London)
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

class getData: ObservableObject{
    private var path = "Classes"
    @Published var data = [DataType]()
    
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
                self.data.append(DataType(id: id, name: name, number: number, major: major))
            }
            
        }
    }
     
}

struct DataType: Identifiable{
    
    @DocumentID var id: String?
    var name: String
    var number: Int
    var major: String
}


struct Detail: View {
    
    var data: DataType
    
    var body: some View{
        Text(String(data.number))
    }
}






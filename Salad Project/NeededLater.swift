//
//  TestView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 8/28/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SearchView: View {
    
    @ObservedObject var data = getData()
    
    var body: some View {

        NavigationView {
            CustomSearchBar(datas: self.$data.data)
                    .padding(.all)
        }
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}


struct CustomSearchBar: View{
    @State var txt = ""
    @Binding var datas: [DataType]
    
    var body: some View{
        
        VStack (spacing: 0){
            HStack{
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
                        .foregroundColor(.black)
                    } else{
                        Image(systemName:"magnifyingglass")
                            .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                            .padding(.trailing)
                    }
                    
                }
                
                
            }.padding()
            
            if self.txt != "" {
                
                if self.datas.filter({$0.name.lowercased().contains(self.txt.lowercased())}).count == 0{
                    Text("No result found").foregroundColor(.black.opacity(0.5)).padding()
                } else{
                    ScrollView {
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
                                            .font(.system(.body, design: .rounded))
                                            .fontWeight(.bold)
                                            .tracking(-0.5)
                                            .foregroundColor(.black)
                                       
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
                        .frame(height: 120)
                        .foregroundColor(Color("SearchbarColor"))
                }
                
                    
            }
        
        }.background(Color.white).padding()
        
        
    }
}




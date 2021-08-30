//
//  ContentView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 8/25/21.
//

import SwiftUI
import MapKit
import CoreLocation

class ClassLocations: ObservableObject{
    @Published var classlocations: [MKPointAnnotation] = []
}

struct ContentView: View {
    @State var height = CGFloat(UIScreen.main.bounds.height)
    @State var width =  CGFloat(UIScreen.main.bounds.width)
    @State var MainTab = CGSize.zero
    @State var ShowClass = false
    
    @State var ClassName = ""
    @ObservedObject var datas = getData()
    
    @State var coordinate: [Double] = [42.05, -87.7]
    @State var showRoute = false
    @StateObject var classes = ClassLocations()
    @ObservedObject var locationManager = LocationManager()
    
    
    var body: some View {
        ZStack () {
            NavigationView{
                VStack{
                    MapView(coordinate: $coordinate, show: $showRoute).environmentObject(classes)
                        .ignoresSafeArea()
                        .accentColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                }
            }
            
            VStack{
                HStack {
                    Spacer()
                    SideButtonView().environmentObject(classes)
                        .padding(.trailing)
                        .padding(.top, self.height / 18)
                }
                Spacer()
                HStack {
                    if self.MainTab.height >= 0 && !self.ShowClass{
                        CornerButtonView()
                            .onTapGesture {
                                self.showRoute.toggle()
                                let London = MKPointAnnotation()
                                London.title = "COMP_SCI 349"
                                London.coordinate = CLLocationCoordinate2D(latitude: 42.05, longitude: -87.67)
                                self.classes.classlocations.append(London)
                                
                            }
                            .foregroundColor(showRoute ? Color(#colorLiteral(red: 0.9176470588, green: 0.3450980392, blue: 0.3019607843, alpha: 1)) : Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                            .offset(y: -self.height / 12 - 44)
                            .padding(.leading)
                            .opacity(Double(1 + self.MainTab.height))
                        Spacer()
                        WeatherView()
                            .offset(y: -self.height / 12 - 44)
                            .padding(.trailing)
                            .opacity(Double(1 + self.MainTab.height))
                            
                            .onTapGesture {
                                let London = MKPointAnnotation()
                                London.title = "COMP_SCI 349"
                                London.coordinate = CLLocationCoordinate2D(latitude: 42.06, longitude: -87.67)
                                self.classes.classlocations.append(London)
                                
                            }
 
                    }
                    
                }
                
                
            }
            .ignoresSafeArea()

            
            VStack() {
                Rectangle()
                    .frame(width: 40.0, height: 4.0)
                    .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                    .cornerRadius(2.0)
                    .padding(.top, 10)
                
                
                ZStack {
                    Rectangle()
                        .frame(height: 34)
                        .cornerRadius(8)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("TextbarColor"))
                        
                    HStack {
                        TextField("Add your class here...", text: $ClassName)
                            .onChange(of: ClassName){ value in
                                self.ShowClass = true
                            }
                            .padding(.leading)
                            
                        Spacer()
                        if self.ClassName != ""{
                            Button(action: {
                                self.ClassName = ""
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
                    .onTapGesture {
                        self.ShowClass = true
                    }
                    
                    
                }
                .padding([.leading, .trailing])

                if self.MainTab.height < -20 || self.ShowClass{
                    //NavigationView {
                    ClassList(txt: self.$ClassName, datas: self.$datas.data).environmentObject(classes)
                            .padding(.top)
                            .gesture(
                                DragGesture().onChanged{ value in
                                    self.MainTab = CGSize.zero
                                }
                        )
                    //}
                    
                }
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color("SearchbarColor"))
            .cornerRadius(8.0)
            .shadow(color: .black, radius: 8, x: 5, y: 10)
            .offset(y: self.MainTab.height)
            .offset(y: ShowClass ? self.height / 6 : self.height / 1.2)
            .gesture(
                DragGesture().onChanged { value in
                    self.MainTab = value.translation
                    if value.translation.height < -40 && self.ShowClass
                        || value.translation.height > 40 && !self.ShowClass{
                        self.MainTab = CGSize.zero
                    }
                    
                }
                .onEnded{ value in
                    if value.translation.height < -80{
                        self.ShowClass = true
                    }
                    else if value.translation.height > 80{
                        self.ShowClass = false
                    }
                    
                    self.MainTab = CGSize.zero
                    
                }
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0))
        }

        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            let classes = ClassLocations()
            ContentView(classes: classes)
                .preferredColorScheme(.dark)
            ContentView(classes: classes)
                .preferredColorScheme(.light)
        }
    }
}


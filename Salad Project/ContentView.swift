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
    
    @Published var userClass: [ClassInfo] = [] {
        didSet{
            savedItems()
        }
    }
    @Published var Section: [ClassInfo] = []
    @Published var detail: [ClassInfo] = []
    @Published var showUserClass = false
    @Published var showRoute = false
    @Published var showUserLocation = false
    @Published var ShowClass = false
    @Published var EditClass = false
    
    init(){
        getItems()
    }
    
    func getItems(){
        guard let data = UserDefaults.standard.data(forKey: "UserClassFile") else { return }
        guard let savedItems = try? JSONDecoder().decode([ClassInfo].self, from: data) else { return }
        
        userClass = savedItems
    }
    
    func savedItems(){
        if let encodedData = try? JSONEncoder().encode(userClass) {
            UserDefaults.standard.set(encodedData, forKey: "UserClassFile")
        }
    }
    
}



class appSettings: ObservableObject{
    
    @Published var currentSystemScheme = schemeTransform(userInterfaceStyle: UITraitCollection.current.userInterfaceStyle)
    @Published var isDarkMode = false
    @Published var Schedule = false
    @Published var Settings = false
    @Published var About = false
    @Published var Bug = false
    
}


struct ContentView: View {
    @State var height = CGFloat(UIScreen.main.bounds.height)
    @State var width =  CGFloat(UIScreen.main.bounds.width)
    @State var MainTab = CGSize.zero
    @State var ShowClass = false
    
    @State var ClassName = ""
    
    
    @StateObject var classes = ClassLocations()
    @ObservedObject var datas = getClass()
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var notificationManager = NotificationManager()
    @StateObject var settings = appSettings()
    
    var body: some View {
        
        ZStack () {
            
            MapView().environmentObject(classes)
                .ignoresSafeArea()
                .accentColor(Color("Theme"))
            
            VStack{
                VStack{
                    HStack {
                        Spacer()
                        SideButtonView()
                            .environmentObject(settings)
                            .padding(.trailing)
                            .padding(.top, height / 18)
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    if MainTab.height >= 0 && !classes.ShowClass{
                        CornerButtonView()
                            .environmentObject(classes)
                            .onTapGesture {
                                classes.showUserLocation.toggle()
                            }
                            .foregroundColor(classes.showUserLocation ? Color("Red") : Color("Theme"))
                            .offset(y: -height / 12 - 50)
                            .padding(.leading)
                            .opacity(Double(1 + MainTab.height))
                        Spacer()
                        
                        if !classes.EditClass{
                            UserClassView().environmentObject(classes)
                                .onTapGesture {
                                    classes.showUserClass.toggle()
                                    classes.detail.removeAll()
                                    classes.Section.removeAll()
                                    if classes.showUserClass {
                                        classes.ShowClass = true
                                    }
                                    
                                }
                                .foregroundColor(classes.showUserClass ? Color("Red") : Color("Theme"))
                                .offset(y: -height / 12 - 50)
                                .padding(.trailing)
                                .opacity(Double(1 + MainTab.height))
                        }
                    }
                    
                }
                
                
            }
            .ignoresSafeArea()
            
            
            
            VStack {
                Rectangle()
                    .frame(width: 40.0, height: 4.0)
                    .foregroundColor(Color("Theme"))
                    .cornerRadius(2.0)
                    .padding(.top, 10)
                
                
                if classes.Section.count == 0 && !classes.EditClass{
                    if classes.detail.isEmpty && !classes.showUserClass{
                        ZStack {
                            Rectangle()
                                .frame(height: 34)
                                .cornerRadius(8)
                                .foregroundColor(Color("TextbarColor"))
                            
                            HStack {
                                TextField("Add your class here...", text: $ClassName)
                                
                                    .onChange(of: ClassName){ value in
                                        classes.ShowClass = true
                                    }
                                
                                    .padding(.leading)
                                
                                Spacer()
                                
                                if ClassName != ""{
                                    Button(action: {
                                        ClassName = ""
                                    }){
                                        Image(systemName: "xmark.circle.fill")
                                            .padding(.trailing)
                                    }
                                    .foregroundColor(.black)
                                } else{
                                    Image(systemName:"magnifyingglass")
                                        .foregroundColor(Color("Theme"))
                                        .padding(.trailing)
                                    
                                }
                            }
                            .onTapGesture {
                                classes.ShowClass = true
                            }
                            
                            
                        }
                        .padding([.leading, .trailing])
                        
                    } else {
                        VStack (alignment: .leading){
                            HStack{
                                VStack (alignment: .leading, spacing: 4){
                                    Text(classes.detail.isEmpty ? "Your Class" : classes.detail[0].Major.components(separatedBy: " ")[0] + " " + classes.detail[0].Class.components(separatedBy: " ")[0] + "-" + classes.detail[0].Section.components(separatedBy: " ")[0].replacingOccurrences(of: ":", with: ""))
                                        .font(.system(.body, design: .rounded))
                                        .fontWeight(.bold)
                                        .tracking(-0.5)
                                        .padding(.trailing)
                                    Text(classes.detail.isEmpty ? "You have \(classes.userClass.count) class(es)" : classes.detail[0].Class.components(separatedBy: " ").dropFirst().joined(separator: " "))
                                        .foregroundColor(.secondary)
                                        .font(.system(.caption2, design: .rounded))
                                        .tracking(-0.5)
                                }
                                
                                Spacer()
                                
                                if !classes.detail.isEmpty || classes.EditClass{
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                        .scaleEffect(1.2)
                                        .padding(.trailing)
                                        .padding(.trailing)
                                        .onTapGesture{
                                            classes.detail.removeAll()
                                            classes.showRoute = false
                                            classes.EditClass = false
                                        }
                                }
                            }
                            
                            .padding(.top, 6)
                            .padding(.leading)
                            .padding(.leading)
                        }
                        
                    }
                       
                    
                    
                } else {
                    HStack{
                        VStack (alignment: .leading, spacing: 4){
                            let message = classes.detail.isEmpty ? "" : ("-" + classes.detail[0].Section.components(separatedBy: " ")[0].replacingOccurrences(of: ":", with: ""))
                            Text(classes.Section[0].Major.components(separatedBy: " ")[0] + " " +  classes.Section[0].Class.components(separatedBy: " ")[0] + message)
                                .foregroundColor(Color("Default"))
                                .font(.system(.body, design: .rounded))
                                .fontWeight(.bold)
                                .tracking(-0.5)
                                .padding(.trailing)
                            Text(classes.Section[0].Class.components(separatedBy: " ").dropFirst().joined(separator: " "))
                                .foregroundColor(.secondary)
                                .font(.system(.caption2, design: .rounded))
                                .tracking(-0.5)
                                .multilineTextAlignment(.leading)
                        }
                        

                        Spacer()
                        
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .scaleEffect(1.2)
                            .padding(.trailing)
                            .padding(.trailing)
                            .onTapGesture{
                                classes.EditClass = false
                                if !classes.showRoute{
                                    classes.ShowClass = true
                                }
                                if classes.detail.isEmpty{
                                    classes.Section = [ClassInfo]()
                                    
                                } else{
                                    classes.showRoute = false
                                }
                                
                                classes.detail.removeAll()
                                
                            }
                    }
                    .padding(.top, 6)
                    .padding(.leading)
                    .padding(.leading)
                    
                }
                
                if MainTab.height < -20 || classes.ShowClass{
                    if classes.EditClass{
                        EditView(datas: datas.data, uniqueProf: datas.uniqueprof).environmentObject(classes)
                    } else {
                        if classes.detail.isEmpty{
                            if !classes.showUserClass{
                                ClassList(txt: $ClassName, datas: $datas.data, uniqueData: $datas.uniquedata, uniqueProf: $datas.uniqueprof).environmentObject(classes)
                                    .environmentObject(settings)
                                    .padding(.top)
                                    .gesture(
                                        DragGesture().onChanged{ value in
                                            MainTab = CGSize.zero
                                        }
                                    )
                            } else {
                                UserClassList().environmentObject(classes)
                            }
                        } else {
                            DetailView().environmentObject(classes)
                        }
                    }
                   
                }
                Spacer()
                
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color("SearchbarColor"))
            .cornerRadius(8.0)
            .offset(y: MainTab.height)
            .offset(y: classes.ShowClass ? height / 6 : height / 1.22)
            .shadow(color: Color("Default").opacity(0.2), radius: 6, x: 3, y: 3)
            .gesture(
                DragGesture().onChanged { value in
                MainTab = value.translation
                if value.translation.height < -40 && classes.ShowClass
                    || value.translation.height > 40 && !classes.ShowClass{
                    MainTab = CGSize.zero
                }
                else if value.translation.height < -height / 1.5 && !classes.ShowClass{
                    MainTab = CGSize.zero
                    classes.ShowClass = true
                }
                
            }
                    .onEnded{ value in
                if value.translation.height < -80{
                    classes.ShowClass = true
                }
                else if value.translation.height > 80{
                    classes.ShowClass = false
                    hideKeyboard()
                }
                
                MainTab = CGSize.zero
                
            }
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0))
            
            
            Rectangle()
                .foregroundColor(Color.black)
                .opacity(0.7)
                .ignoresSafeArea()
                .offset(y: (settings.Settings || settings.Schedule || settings.About || settings.Bug) ? 0 : height)
                .onTapGesture(){
                    settings.Settings = false
                }
            
            
            ScheduleView()
                .environmentObject(settings)
                .offset(y: settings.Schedule ?  0 : height)
                .animation(.spring())
            
            SettingsView()
                .environmentObject(settings)
                .environmentObject(classes)
                .offset(y: settings.Settings ? height / 3.2 : height)
                .animation(.spring())
            
            AboutView()
                .environmentObject(settings)
                .offset(y: settings.About ?  0 : height)
                .animation(.spring())
            
            BugView()
                .environmentObject(settings)
                .offset(y: settings.Bug ?  height / 4.8 : height)
                .animation(.spring())
            
            
        }
        .preferredColorScheme(settings.currentSystemScheme)
        .onAppear{
            notificationManager.reloadAuthorizationStatus()
            notificationManager.emptyLocalNotifications()
            ForEach (classes.userClass, id: \.self){ classInfo in
                let hours = scrapeStartHoursMinutes(rawString: classInfo.MeetingInfo)
                
            }
            notificationManager.createNotification(title: "You have an upcoming class", body: "Your class is happening in 10 minutes", hour: 1, min: 11){error in
                if error != nil{
                    return
                }
            }
        }
        .onChange(of: notificationManager.authorizationStatus){ authorizationStatus in
            switch authorizationStatus {
            case .notDetermined:
                notificationManager.requestAuthorization()
            case .authorized:
                notificationManager.reloadLocalNotifications()
                break
            default:
                break
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)){_ in
            notificationManager.reloadAuthorizationStatus()
        }
        .onDisappear{
            notificationManager.reloadLocalNotifications()
        }
        
        
        
        
        
        
    }
    
}


extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

func schemeTransform(userInterfaceStyle:UIUserInterfaceStyle) -> ColorScheme {
    if userInterfaceStyle == .light {
        return .light
    }else if userInterfaceStyle == .dark {
        return .dark
    }
    return .light}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ContentView()
                .preferredColorScheme(.dark)
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}


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
    @Published var usedClass: [ClassInfo] = [] {
        didSet{
            saveusedClass()
        }
    }
    @Published var Quarter: String = "Spring 2022" {
        didSet{
            saveQuarters()
        }
    }
    
    @Published var Section: [ClassInfo] = []
    @Published var detail: [ClassInfo] = []
    @Published var showUserClass = false
    @Published var showRoute = false
    @Published var showUserLocation = false
    @Published var ShowClass = false
    @Published var EditClass = false
    @Published var showAlert = false
    @Published var quickNavigate = false
    @Published var Time = 0
    @Published var quickNavigateTime = 31
    @Published var quickNavigateclass: [ClassInfo] = []
    
    @Published var startTime: Int = 9
    @Published var endTime: Int = 17
    
    
    init(){
        getItems()
        getQuarter()
    }
    
    func getItems(){
        guard let data = UserDefaults.standard.data(forKey: "UserClassFile") else { return }
        guard let savedItems = try? JSONDecoder().decode([ClassInfo].self, from: data) else { return }
        guard let usedData = UserDefaults.standard.data(forKey: "usedClass") else { return }
        guard let usedSavedItems = try? JSONDecoder().decode([ClassInfo].self, from: usedData) else { return }
        
        userClass = savedItems
        usedClass = usedSavedItems
        
    }
    func getQuarter(){
        Quarter = UserDefaults.standard.string(forKey: "Quarter") ?? Quarter
    }
    
    func savedItems(){
        if let encodedData = try? JSONEncoder().encode(userClass) {
            UserDefaults.standard.set(encodedData, forKey: "UserClassFile")
        }
        if let encodedData = try? JSONEncoder().encode(usedClass) {
            UserDefaults.standard.set(encodedData, forKey: "usedClass")
        }
        
        var startTimeList = userClass.map{separateHourMinute(scrapedString: scrapeStartHoursMinutes(rawString: $0.MeetingInfo))[0]}
        var endTimeList = userClass.map{separateHourMinute(scrapedString: scrapeEndHoursMinutes(rawString: $0.MeetingInfo))[0]}
        startTimeList = startTimeList.filter({$0 != -1})
        endTimeList = endTimeList.filter({$0 != -1})
        startTime = startTimeList.isEmpty ? 9 : startTimeList.min()! - 1
        endTime = endTimeList.isEmpty ? 17 : endTimeList.max()! + 2
        
        
        let startHour = separateHourMinute(scrapedString: scrapeStartHoursMinutes(rawString: detail.isEmpty ? "" : detail[0].MeetingInfo))[0]
        let endHour = separateHourMinute(scrapedString: scrapeEndHoursMinutes(rawString: detail.isEmpty ? "" : detail[0].MeetingInfo))[0]
        startTime = startHour == -1 ? startTime : min(startTime, startHour - 1)
        endTime = endHour == -1 ? endTime : max(endTime, endHour + 2)
    }
    
    func saveQuarters(){
        if UserDefaults.standard.string(forKey: "Quarter") != nil && UserDefaults.standard.string(forKey: "Quarter") != Quarter{
            let tempClass = usedClass
            usedClass = userClass
            userClass = tempClass
            showAlert = true
        }
        UserDefaults.standard.set(Quarter, forKey: "Quarter")
    }
    
    func saveusedClass(){
        if let encodedData = try? JSONEncoder().encode(usedClass) {
            UserDefaults.standard.set(encodedData, forKey: "usedClass")
        }
    }
    
    
}



class appSettings: ObservableObject{
    
    @Published var currentSystemScheme = schemeTransform(userInterfaceStyle: UITraitCollection.current.userInterfaceStyle)
    @Published var isDarkMode: String = "Automatic" {
        didSet{
            saveDarkMode()
        }
    }
    
    @Published var TimeInAdvance: Int = 10 {
        didSet{
            saveTime()
        }
    }
    
    @Published var timeline: Bool = false {
        didSet{
            saveTimeLine()
        }
    }
    
    @Published var hidePastEvent: Bool = false {
        didSet{
            saveHidePastEvent()
        }
    }
    
    @Published var Schedule = true
    @Published var Settings = false
    @Published var About = false
    @Published var Bug = false
    @Published var showAlert = false
    
    init(){
        getTime()
        getDarkMode()
        getTimeLine()
        getHidePastEvent()
    }
    
    func getTime(){
        TimeInAdvance = UserDefaults.standard.integer(forKey: "TimeInAdvance")
    }
    
    func getDarkMode(){
        isDarkMode = UserDefaults.standard.string(forKey: "isDarkMode") ?? isDarkMode
        
        if isDarkMode == "Dark"{
            currentSystemScheme = .dark
        } else if isDarkMode == "Light" {
            currentSystemScheme = .light
        } else {
            currentSystemScheme = schemeTransform(userInterfaceStyle: UITraitCollection.current.userInterfaceStyle)
        }
    }
    
    func getTimeLine(){
        timeline = UserDefaults.standard.bool(forKey: "TimeLine")
    }
    
    func getHidePastEvent(){
        hidePastEvent = UserDefaults.standard.bool(forKey: "HidePastEvent")
    }

    func saveTime(){
        UserDefaults.standard.set(TimeInAdvance, forKey: "TimeInAdvance")
    }
    
    func saveTimeLine(){
        UserDefaults.standard.set(timeline, forKey: "TimeLine")
    }
    
    func saveHidePastEvent(){
        UserDefaults.standard.set(hidePastEvent, forKey: "HidePastEvent")
    }
    
    func saveDarkMode(){
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        if isDarkMode == "Dark"{
            currentSystemScheme = .dark
        } else if isDarkMode == "Light" {
            currentSystemScheme = .light
        } else {
            currentSystemScheme = schemeTransform(userInterfaceStyle: UITraitCollection.current.userInterfaceStyle)
        }
    }
}


struct ContentView: View {
    @State var height = CGFloat(UIScreen.main.bounds.height)
    @State var width =  CGFloat(UIScreen.main.bounds.width)
    @State var MainTab = CGSize.zero
    @State var ShowClass = false
    
    @State var ClassName = ""
    @StateObject var classes = ClassLocations()
    @StateObject var settings = appSettings()
    @ObservedObject var datas = getClass()
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var notificationManager = NotificationManager()
    
    var body: some View {

        ZStack () {
            
            !settings.Schedule ?
                MapView()
                    .environmentObject(classes)
                    .environmentObject(settings)
                    .accentColor(Color("Theme"))
                    .ignoresSafeArea()
                : nil
            
            settings.Schedule ?
                ScheduleView()
                    .environmentObject(settings)
                    .environmentObject(classes)
                : nil
            
            VStack{
                Spacer()
                HStack {
                    if MainTab.height >= 0 && !classes.ShowClass{
                        CornerButtonView()
                            .onTapGesture {
                                settings.Settings.toggle()
                                classes.quickNavigate = false
                            }
                            .foregroundColor(Color("Theme"))
                            .offset(y: -height / 12 - 50)
                            .padding(.leading)
                            .opacity(Double(1 + MainTab.height))
                        Spacer()
                        
                        if !classes.EditClass{
                            ScheduleButtonView()
                                .environmentObject(settings)
                                .onTapGesture {
                                    settings.Schedule.toggle()
                                    classes.quickNavigate = false
                                }
                                .foregroundColor(Color("Theme"))
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
                                        .fontWeight(.semibold)
                                        .font(.system(.caption, design: .rounded))
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
                                            classes.Time = 0
                                            
                                            var startTimeList = classes.userClass.map{separateHourMinute(scrapedString: scrapeStartHoursMinutes(rawString: $0.MeetingInfo))[0]}
                                            var endTimeList = classes.userClass.map{separateHourMinute(scrapedString: scrapeEndHoursMinutes(rawString: $0.MeetingInfo))[0]}
                                            startTimeList = startTimeList.filter({$0 != -1})
                                            endTimeList = endTimeList.filter({$0 != -1})
                                            classes.startTime = startTimeList.isEmpty ? 9 : startTimeList.min()! - 1
                                            classes.endTime = endTimeList.isEmpty ? 17 : endTimeList.max()! + 2
                                            
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
                                .font(.system(.footnote, design: .rounded))
                                .fontWeight(.semibold)
                                .tracking(-0.5)

                        }
                        

                        Spacer()
                        
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .scaleEffect(1.2)
                            .padding(.trailing)
                            .padding(.trailing)
                            .onTapGesture{
                                if !classes.EditClass{
                                    classes.detail.removeAll()
                                }
                                classes.EditClass = false
                                if !classes.showRoute{
                                    classes.ShowClass = true
                                }
                                if classes.detail.isEmpty{
                                    classes.Section = [ClassInfo]()
                                    
                                } else{
                                    classes.showRoute = false
                                }
                                
                                classes.Time = 0
                            }
                    }
                    .padding(.top, 6)
                    .padding(.leading)
                    .padding(.leading)
                    
                }
                
                if MainTab.height < -20 || classes.ShowClass{
                    if classes.EditClass{
                        EditView(datas: datas.data, uniqueProf: datas.uniqueprof, ClassLocation: classes.detail[0].MeetingInfo.components(separatedBy: ": ")[0])
                            .environmentObject(classes)
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
                                UserClassList()
                                    .environmentObject(classes)
                            }
                        } else {
                            DetailView()
                                .environmentObject(classes)
                                .environmentObject(settings)
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
                    classes.quickNavigate = false
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
            
            
            (settings.Settings  || settings.About || settings.Bug) ? Rectangle()
                .foregroundColor(Color.black)
                .opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture(){
                    settings.Settings = false
                } : nil
            
            SettingsView()
                .environmentObject(settings)
                .environmentObject(classes)
                .offset(y: settings.Settings ? height / 3.2 : height * 2)
                .animation(.spring())
            
            AboutView()
                .environmentObject(settings)
                .offset(y: settings.About ?  0 : height)
                .animation(.spring())
            
            BugView()
                .environmentObject(settings)
                .offset(y: settings.Bug ?  height / 4 : height * 2)
                .animation(.spring())
            
            QuickNavigationWindow()
                .environmentObject(classes)
                .environmentObject(settings)
                .offset(y: classes.quickNavigate ?  0 : height * 2)
                .animation(.spring())
            
        }
        .preferredColorScheme(settings.currentSystemScheme)
        .onAppear{
            
            let date = Date()
            let hour = Calendar.current.component(.hour, from: date)
            let minute = Calendar.current.component(.minute,from: date)
            let week = Calendar.current.component(.weekday, from: date)
            var maxInterval = settings.TimeInAdvance + 1
            
            notificationManager.reloadAuthorizationStatus()
            notificationManager.emptyLocalNotifications()
            
            for classInfo in classes.userClass{

                var start = separateHourMinute(scrapedString: scrapeStartHoursMinutes(rawString: classInfo.MeetingInfo))
                
                if start.contains(-1){
                    continue
                    
                }
                
                let startHour = start[0]
                let startMinute = start[1]
                start = timeWithDelay(timeList: start, delay: settings.TimeInAdvance)
                let startHours = start[0]
                let startMinutes = start[1]
                
                let notificationBody = classInfo.Major.components(separatedBy: " ")[0] + " " + classInfo.Class.components(separatedBy: " ")[0] + "-" + classInfo.Section.components(separatedBy: " ")[0].replacingOccurrences(of: ":", with: "")
                
                let location = classInfo.MeetingInfo.components(separatedBy: ": ")[0]
                
                let dow = switchDaysWithInt(dowList: scrapeDatesOfWeek(rawString: classInfo.MeetingInfo))
                
                if !dow.contains(-1) && startHours != -1 && startMinutes != -1 {
                    for weekday in dow{
                        notificationManager.createNotification(title: "You have an upcoming class", body: "\(notificationBody) at \(location) is in \(settings.TimeInAdvance) minutes", hour: startHours, min: startMinutes, weekday: weekday){error in
                            if error != nil{
                                return
                            }
                        }
                        if week == weekday{
                            let interval = timeInterval(currentHour: hour, currentMinute: minute, classHour: startHour, classMinute: startMinute)
                            if interval >= 0 && interval < maxInterval{
                                maxInterval = interval
                                if classes.quickNavigateclass.isEmpty{
                                    classes.quickNavigateclass.append(classInfo)
                                } else {
                                    classes.quickNavigateclass[0] = classInfo
                                }
                            }
                        }
                    }
                }
            }
            
            if maxInterval < settings.TimeInAdvance{
                classes.quickNavigate = true
                classes.quickNavigateTime = maxInterval
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


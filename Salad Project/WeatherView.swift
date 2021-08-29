//
//  WeatherView.swift
//  ClassFinder
//
//  Created by Kevin Su on 26/8/2021.
//
//WeatherView: Window displaying weather, temperature, and AQI
import SwiftUI

struct WeatherView: View {
    var body: some View {
        ZStack{
        
        Rectangle() //Background rectangle
            .cornerRadius(8.0)
            .frame(width: 80.0, height: 50.0)
            .foregroundColor(Color("ClassColor"))
            .opacity(0.6)
            .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
            
            
        VStack
        {
            HStack{
                //Weather filler
                Image(systemName: "cloud")
                    .scaleEffect(1.4)
                        
                    
                //Temperature filler
                Text("75")
                    .font(.title2)
                    .fontWeight(.light)
                
            }
            .padding(.top, 2.0)
            .frame(width: 75.0, height: 30)
            
            //AQI filler
            Text("AQI 41")
                .font(.subheadline)
                .fontWeight(.light)
        }
        }
            
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}

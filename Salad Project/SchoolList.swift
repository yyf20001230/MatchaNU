//
//  ClassList.swift
//  Salad Project
//
//  Created by Yunfan Yang on 8/25/21.
//

import Foundation

struct School: Identifiable {
    let id = UUID()
    let logoName: String
    let title: String
    let description: String
}

struct SchoolList {
    
    static let Schools = [
        School(logoName: "MEAS",
              title: "MEAS",
              description: "McCormick School of Engineering and Applied Science"),
              
        
        School(logoName: "JOUR",
              title: "JOUR",
              description: "Medill School of Journalism"),
        
        School(logoName: "LAW",
               title: "LAW",
               description: "Law School"),
        
        School(logoName: "MUSIC",
               title: "MUSIC",
               description: "Bienen School of Music"),
        
        School(logoName: "SESP",
               title: "SESP",
               description: "School of Education and Social Policy"),
        
        School(logoName: "TGS",
               title: "TGS",
               description: "The Graduate School"),
        
        School(logoName: "KGSM",
               title: "KGSM",
               description: "J.L.Kellogg School of Management"),
        
        School(logoName: "SPCH",
               title: "SPCH",
               description: "School of Communication"),
        
        School(logoName: "UC",
               title: "UC",
               description: "School of Professional Studies"),
        
        School(logoName: "WCAS",
               title: "WCAS",
               description: "Weinberg School of Art and Science")
        
    ]
}

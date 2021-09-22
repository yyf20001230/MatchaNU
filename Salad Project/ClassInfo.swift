//
//  ClassInfo.swift
//  Salad Project
//
//  Created by Yunfan Yang on 9/21/21.
//

import Foundation


public class DataLoader{
    
    @Published var classInfo = [ClassInfo]()
    @Published var uniqueInfo = [ClassInfo]()
    
    init(){
        load()
    }
    
    func load(){
        if let fileLocation = Bundle.main.url(forResource: "ClassInfo", withExtension: "json") {
            do {
                let classData = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let datafromJson = try jsonDecoder.decode([ClassInfo].self,from: classData)
                
                self.classInfo = datafromJson
            }
            catch {
                print(error)
            }
        }
    }
    
}


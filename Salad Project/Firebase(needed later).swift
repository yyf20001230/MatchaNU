//
//  SearchView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 8/28/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

struct ClassCard: Identifiable, Codable{
    @DocumentID var id: String?
    var name: String
    var number: Int
}

final class ClassRepository: ObservableObject{
    private let path = "Classes"
    private let store = Firestore.firestore()
    @ Published var Classes: [ClassCard] = []
    
    init(){
        get()
    }
    
    func get(){
        store.collection(path).addSnapshotListener{ (snapshot, error) in
            if let error = error{
                print(error)
                return
            }
            self.Classes = snapshot?.documents.compactMap {
                try? $0.data(as: ClassCard.self)
            } ?? []
        }
    }
    
    func add(_ classCard: ClassCard){
        do{
            _ = try store.collection(path).addDocument(from: classCard)
        } catch{
            fatalError("Adding a class card failed")
        }
    }
    
    func remove(_ classCard: ClassCard){
        guard let documentID = classCard.id else { return }
        store.collection(path).document(documentID).delete{ error in
            if let error = error{
                print("Unable to remove the card: \(error.localizedDescription)")
            }
        }
    }
    
    func update(_ classCard: ClassCard){
        guard let documentID = classCard.id else { return }
        do{
            try store.collection(path).document(documentID).setData(from: classCard)
        } catch {
            fatalError("Updating a class card failed")
        }
    }
    
}

final class ClassListViewModel: ObservableObject{
    @Published var classRepository =  ClassRepository()
    @Published var Classes: [ClassCard] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        classRepository.$Classes.assign(to: \.Classes, on: self).store(in: &cancellables)
    }
    
    func add(_ classCard: ClassCard){
        classRepository.add(classCard)
    }
    
    func remove(_ classCard: ClassCard){
        classRepository.remove(classCard)
    }
    
    func update(_ classCard: ClassCard){
        classRepository.update(classCard)
    }
    
    
}





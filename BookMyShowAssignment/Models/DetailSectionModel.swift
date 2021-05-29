//
//  DetailSectionModel.swift
//  BookMyShowAssignment
//
//  Created by Sri Sai Sindhuja, Kanukolanu on 29/05/21.
//

import Foundation

struct DetailSectionModel: Hashable, Equatable {
    
    var title: String
    var rows: [DetailDataModel]
    
    let uniqueId = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueId)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uniqueId == rhs.uniqueId
    }
}

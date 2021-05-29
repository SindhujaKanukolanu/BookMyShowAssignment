//
//  DetailDataModel.swift
//  BookMyShowAssignment
//
//  Created by Sri Sai Sindhuja, Kanukolanu on 29/05/21.
//

import Foundation

struct DetailDataModel:Hashable {
    
    static func == (lhs: DetailDataModel, rhs: DetailDataModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var overView   : String
    var ratings    : NSNumber
    var language   : String
    
}

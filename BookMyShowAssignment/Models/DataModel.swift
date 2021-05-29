//
//  DataModel.swift
//  BookMyShowAssignment
//
//  Created by Sri Sai Sindhuja, Kanukolanu on 28/05/21.
//

import Foundation
import UIKit

struct DataModel:Hashable {
    
    static func == (lhs: DataModel, rhs: DataModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var movieName   : String
    var image       : UIImage
    var releaseDate : String
}

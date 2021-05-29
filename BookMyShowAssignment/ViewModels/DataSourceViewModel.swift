//
//  DataSourceViewModel.swift
//  BookMyShowAssignment
//
//  Created by Sri Sai Sindhuja, Kanukolanu on 28/05/21.
//

import Foundation
import Combine
import UIKit

enum NetworkError: Error {
    case Success
    case Failure
}

class DataSourceViewModel {
    
    var cards = [SectionModel]()
    
    init() {
        buildCells()
    }
    
    private func buildCells() {
        let bmsModel = SectionModel(title: "",
                                    rows: [DataModel(movieName: "Baahubali", image: UIImage(named: "bmsImage.jpeg") ?? UIImage(),
                                                     releaseDate: "2015"),
                                           DataModel(movieName: "Dilwale Dulhaniya LeJayenge", image: UIImage(named: "bmsImage.jpeg") ?? UIImage(),
                                                     releaseDate: "2015"),
                                           DataModel(movieName: "Dostana", image: UIImage(named: "bmsImage.jpeg") ?? UIImage(),
                                                     releaseDate: "2015"),
                                           DataModel(movieName: "Happydays", image: UIImage(named: "bmsImage.jpeg") ?? UIImage(),
                                                     releaseDate: "2015"),
                                           DataModel(movieName: "Hello", image: UIImage(named: "bmsImage.jpeg") ?? UIImage(),
                                                     releaseDate: "2015")])
        cards = [bmsModel]
    }
    
    //    func fetchCatalogCards() -> AnyPublisher<[SectionModel], CatalogError> {
    //        return Future { promise in
    //            DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
    //                guard var updatedCards = self?.cards else {
    //                    promise(.failure(.Unknown))
    //                    return
    //                }
    //                let colleagueSectionModel = SectionModel(title: "Co-Worker", rows:
    //                                                            [RowModel(name: "Nitin", detail: "xxx@gmail.com", type: .A),
    //                                                             RowModel(name: "Prashanth", detail: "xxx@gmail.com", type: .A),
    //                                                             RowModel(name: "Ramya", detail: "xxx@gmail.com", type: .A),
    //                                                             RowModel(name: "Sindhu", detail: "xxx@gmail.com", type: .A),
    //                                                             RowModel(name: "Reshma", detail: "xxx@gmail.com", type: .A),
    //                                                             RowModel(name: "Apoorv", detail: "xxx@gmail.com", type: .A)])
    //                updatedCards.append(colleagueSectionModel)
    //
    //                //also update state of view model cards
    //                self?.cards.append(colleagueSectionModel)
    //                promise(.success(updatedCards))
    //            }
    //        }.eraseToAnyPublisher()
    //    }
    
}

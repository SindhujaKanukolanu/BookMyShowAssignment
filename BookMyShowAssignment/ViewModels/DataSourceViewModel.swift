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
    var detailCards = [DetailSectionModel]()
    var detailViewCards = [DetailSectionModel]()
    private var cancellable: AnyCancellable?
    var jsonObject = [String:AnyObject]()
    var allCancellable = Set<AnyCancellable>()
    var models = [SectionModel]()


    
    init() {
        getResponseData()
    }
        
    func getResponseData() {
        if let urlString = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=ca236800fe491eba2aad88c0a349bc2e&language=en-US") {
            let jsonPublisher =  URLSession.shared.dataTaskPublisher(for: urlString)
                .tryMap ({ (data, response) -> Data in
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 400 {
                            print("unauthorized")
                        }
                    }
                    return data
                }).decode(type: Model.self, decoder: JSONDecoder()).eraseToAnyPublisher()
                
           // consume the value to Upadte the model
            jsonPublisher.sink { (completion) in
                switch(completion) {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("sink finished sucessfullhy")
                }
            } receiveValue: {(users: Model) in
                self.updateSectionModel(models: users)
            }.store(in: &allCancellable)
        }
    }
    
    func updateSectionModel(models:Model) {
        for each in models.results {
            let cardModel = SectionModel(title:"", rows: [DataModel(movieName: each.originalTitle, image: UIImage(named:"bmsImage.jpeg") ?? UIImage(), releaseDate: each.releaseDate)])
            let detailModel =
                DetailSectionModel(title: each.title, rows: [DetailDataModel(overView: each.overview, ratings: each.voteAverage, language: getLanguageFromCode(lang:each.originalLanguage.rawValue))])
            detailCards.append(detailModel)
            cards.append(cardModel)
        }
    }
    
    func fetchCards() -> AnyPublisher<[SectionModel], NetworkError> {
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let updatedCards = self?.cards else {
                    promise(.failure(.Failure))
                    return
                }
                promise(.success(updatedCards))
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchDetailCards() -> AnyPublisher<[DetailSectionModel], NetworkError> {
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
                guard let updatedCards = self?.detailViewCards else {
                    promise(.failure(.Failure))
                    return
                }
                promise(.success(updatedCards))
            }
        }.eraseToAnyPublisher()
    }
    
    
    func convertStringToDictionary(data: Data) -> [String:AnyObject] {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
            jsonObject = json!
            return json!
        } catch {
            print("Something went wrong")
        }
        return jsonObject
    }
    
    func convertDateFormat(inputDate: String) -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd"
        let oldDate = olDateFormatter.date(from: inputDate)
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "dd-MM-yyyy"
        return convertDateFormatter.string(from: oldDate!)
    }

    func getDetailsCard(indexPath : Int) {
        detailViewCards.removeAll()
        detailViewCards.append(detailCards[indexPath])
    }
    func getLanguageFromCode(lang:String) -> String {
        let locale = Locale(identifier: Locale.current.identifier).localizedString(forLanguageCode: lang)
        let languageValue = "Language :" + (locale ?? "English")
        return languageValue
    }
}

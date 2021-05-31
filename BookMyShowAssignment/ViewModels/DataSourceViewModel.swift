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

    
    init() {
        getResponse()
    }
        
    func getResponse() {
        let urlString = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=ca236800fe491eba2aad88c0a349bc2e&language=en-US")
        self.cancellable = URLSession.shared.dataTaskPublisher(for: urlString ?? URL(fileURLWithPath: ""))
            .map {
                self.jsonObject = self.convertStringToDictionary(data: $0.data)
            }
        .eraseToAnyPublisher()
            .sink(receiveCompletion:  { completion in
                }, receiveValue: { posts in
                    _ = self.updateModel(json: self.jsonObject)
                })
    }
    
    func fetchCards() -> AnyPublisher<[SectionModel], NetworkError> {
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
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
    
    func updateModel(json:[String:AnyObject]) -> [SectionModel] {
        let resultString = json["results"]
        for each in resultString as! [AnyObject]{
            let model = SectionModel(title: "", rows: [DataModel(movieName: each["title"] as! String, image: UIImage(named:"bmsImage.jpeg") ?? UIImage(),releaseDate: convertDateFormat(inputDate: each["release_date"] as! String))])
            cards.append(model)
            buildDetailsModel(object: each)
        }
        return cards
    }
    
    func convertDateFormat(inputDate: String) -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd"
        let oldDate = olDateFormatter.date(from: inputDate)
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "dd-MM-yyyy"
        return convertDateFormatter.string(from: oldDate!)
    }
    
    func buildDetailsModel(object:AnyObject) {
        let detailModel = DetailSectionModel(title: "Synopsis", rows: [DetailDataModel(overView: object["overview"] as! String, ratings: object["vote_average"] as! NSNumber, language: getLanguageFromCode(lang:object["original_language"] as! String))])
        detailCards.append(detailModel)
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

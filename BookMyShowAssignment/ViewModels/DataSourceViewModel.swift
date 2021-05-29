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
        sendUrlRequest()
    }
    
    func sendUrlRequest() {
        let urlString = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=ca236800fe491eba2aad88c0a349bc2e&language=en-US")
        let task = URLSession.shared.dataTask(with: urlString ?? URL(fileURLWithPath: "")) {(data, response, error) in
            guard let data = data else { return }
            _ = self.parseJson(json: self.convertStringToDictionary(data: data))
        }
        task.resume()
        
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
    
    func convertStringToDictionary(data: Data) -> [String:AnyObject] {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
            return json!
        } catch {
            print("Something went wrong")
        }
        return [String:AnyObject]()
    }
    
    func parseJson(json:[String:AnyObject]) -> [SectionModel] {
        let resultString = json["results"]
        for each in resultString as! [AnyObject]{
            print(each)
            let model = SectionModel(title: "", rows: [DataModel(movieName: each["title"] as! String, image: UIImage(contentsOfFile: each["backdrop_path"] as! String) ?? UIImage(),releaseDate: convertDateFormat(inputDate: each["release_date"] as! String))])
            cards.append(model)
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
}

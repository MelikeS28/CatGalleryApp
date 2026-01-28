//
//  NetworkManager.swift
//  CatGalleryApp
//
//  Created by Melike on 29.12.2025.
//

import Foundation
import UIKit
import Alamofire

final class  NetworkManager {
    static let shared = NetworkManager()
    
    private init(){}
    
    let url = "https://api.thecatapi.com/v1/images/search"
    
    private var apiKey: String {
            guard
                let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
                let dict = NSDictionary(contentsOfFile: path),
                let key = dict["CAT_API_KEY"] as? String
            else {
                fatalError("API Key not found")
            }
            return key
        }

        private var headers: HTTPHeaders {
            return [
                "x-api-key": apiKey
            ]
        }

    func fetchCatImages(completion : @escaping(Result<UIImage,Error>)-> Void) {
        AF.request(url, headers: headers).responseData { response in

                switch response.result {

                case .success(let data):
                    do {
                        let cats = try JSONDecoder().decode([Cat].self, from: data)

                        guard let firstCat = cats.first,
                              let imageURL = URL(string: firstCat.url) else {
                            completion(.failure(NSError(domain: "InvalidData", code: 0)))
                            return
                        }
                        AF.request(imageURL).responseData { imageResponse in
                            guard let imageData = imageResponse.data,
                                  let image = UIImage(data: imageData) else {
                                completion(.failure(NSError(domain: "ImageError", code: 0)))
                                return
                            }
                            DispatchQueue.main.async {
                                completion(.success(image))
                            }

                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }

                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
    }
}


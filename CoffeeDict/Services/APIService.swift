//
//  APIService.swift
//  CoffeeDict
//
//  Created by DHIKA ADITYA ARE on 13/01/22.
//

import Foundation

enum NetworkError: Error{
    case decodingError
    case domainError
    case urlError
}

//MARK: Create HTTP Method
enum HttpMethod: String{
    case get = "GET"
    case post = "POST"
}

struct Resources<T: Codable>{
    let url: URL
    var httpMethod: HttpMethod = .get
    var body: Data? = nil //Kita memboleh kan resource untuk mempunyai body
}

extension Resources{
    init(url: URL){
        self.url = url
    }
}

class APIService{
    func load<T>(resource: Resources<T>, completionHandler: @escaping (Result<T, NetworkError>) -> Void){
        
        //MARK: Tambah Lesson 29(it can be reusable for another service)
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //Umwrap data yg berhasil diparsing URLSession
            guard let data = data, error == nil else{
                completionHandler(.failure(.domainError))
                return
            }
            print(data)
            
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result{
                DispatchQueue.main.async {
                    completionHandler(.success(result))
                }
            }else{
                completionHandler(.failure(.decodingError))
            }
        }.resume()
    }
    
    
    func post<T>(resource: Resources<T>, completionHandler: @escaping (Result<T, NetworkError>) -> Void){
        
        //MARK: Tambah Lesson 29(it can be reusable for another service)
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //Umwrap data yg berhasil diparsing URLSession
            guard let data = data, error == nil else{
                completionHandler(.failure(.domainError))
                return
            }
            print(data)
            
//            if let data =  resource.body{
//                DispatchQueue.main.async {
//                    completionHandler(.success(data))
//                }
//            }else{
//                completionHandler(.failure(.decodingError))
//            }
            
//            let result = try? JSONDecoder().decode(T.self, from: data)
//            if let result = result{
//                DispatchQueue.main.async {
//                    completionHandler(.success(result))
//                }
//            }else{
//                completionHandler(.failure(.decodingError))
//            }
        }.resume()
    }
}

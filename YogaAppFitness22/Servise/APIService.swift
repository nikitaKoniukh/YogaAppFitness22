//
//  APIService.swift
//  YogaAppFitness22
//
//  Created by Nikita Koniukh on 06/02/2024.
//

import Foundation

public class APIService {
    static let shared = APIService()
    
    private init(){}
    
    enum APIServiceError: Error {
        case noFile
        case cantLoadFile
        case cantParse
    }
    
    func load(_ filename: String, completion: @escaping (Result<[Session], Error>) -> Void) {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
            completion(.failure(APIServiceError.noFile))
            return
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            completion(.failure(APIServiceError.cantLoadFile))
            return
        }

        do {
            let decoder = JSONDecoder()
            let sessions = try decoder.decode(Sessions.self, from: data)
            completion(.success(sessions.array))

        } catch {
            completion(.failure(APIServiceError.cantParse))
        }
    }
}

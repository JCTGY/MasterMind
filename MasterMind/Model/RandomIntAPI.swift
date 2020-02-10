//
//  RandomIntAPI.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/6/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import Foundation

protocol RandomAPIDelegate {
    // MAKR: - RandomAPIDelegate to transfer fetch data

    func didUpdateRandomAPI(stringData: String, _ isNormalMode: Bool)
    func didFailWithError(error: Error)
}

struct RandomIntAPI {
    
    let baseURL = "https://www.random.org/integers/?col=1&base=10&format=plain&"
    let num: Int
    let min: Int
    let max: Int
    
    var delegate: RandomAPIDelegate?

    func fetchRandomInt(isNormalMode: Bool) {
        
        let urlString = "\(baseURL)num=\(num)&min=\(min)&max=\(max)&rnd=new"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let error = error {
                self.delegate?.didFailWithError(error: error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                    return
            }
            guard let data = data else { return }
            if let stringData = String(bytes: data, encoding: .utf8) {
                self.delegate?.didUpdateRandomAPI(stringData: stringData, isNormalMode)
            }
        }
        task.resume()
    }
}

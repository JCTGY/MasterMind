//
//  RandomIntAPI.swift
//  MasterMind
//
//  Created by jeffrey chiang on 2/6/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import Foundation

protocol RandomAPIDelegate {

  // MARK: - RandomAPIDelegate to transfer fetch data

  func didUpdateRandomAPI(stringData: String, _ isNormalMode: Bool)
  func didFailWithError(error: Error, _ isNormalMode: Bool)
}

/**
## RandomIntAPI

fetching Data from ramdom.org

- parameter num: number of integers want to fetch
- parameter min: minimun number of the interger
- parameter max: maximum number of the integer

## Example

    let randomAPI = RandomIntAPI(num: 4, min: 0, max: 7)
    ramdomAPI.fetchRandomInt(isNormalMode: true)
 fetch 4 number from 0 to 7

## Warnings
 make sure to have `RandomAPIDelegate`, so can catch the data
*/
struct RandomIntAPI {
  let baseURL = "https://www.random.org/integers/?col=1&base=10&format=plain&"
  let num: Int
  let min: Int
  let max: Int

  var delegate: RandomAPIDelegate?
  
  /**
   fetchRandomInt fetch column of interger from random.org
   https://www.random.org/integers

   - parameter isNormalMode: indicate is it normal mode or hard mode
   - returns: Void
   - warning: make sure have `RandomAPIDelegate` to receive the fetching data
   */
  func fetchRandomInt(isNormalMode: Bool) {

    let urlString = "\(baseURL)num=\(num)&min=\(min)&max=\(max)&rnd=new"
    let url = URL(string: urlString)!
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
      if let error = error {
        self.delegate?.didFailWithError(error: error, isNormalMode)
        return
      }
      guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode) else {
          print("Error with the response, unexpected status code: \(String(describing: response))")
          return
      }
      guard let data = data
        else {
          return
      }
      if let stringData = String(bytes: data, encoding: .utf8) {
        self.delegate?.didUpdateRandomAPI(stringData: stringData, isNormalMode)
      }
    }
    task.resume()
  }
}

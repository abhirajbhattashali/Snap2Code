//
//  FetchLanguageID.swift
//  GenerativeAICompiler
//
//  Created by Abhiraj on 01/01/24.
//


import Foundation

func fetchLanguageId(for languageName: String, completion: @escaping (Int?, Error?) -> Void) {
    // Define the URL and headers for the request
    let urlString = "https://judge0-ce.p.rapidapi.com/languages"
    let headers = [
        "X-RapidAPI-Key": "136b3ee2bemsh702a58d48ad0552p179ca8jsnebcc3300f5df", // Replace with your actual API key
        "X-RapidAPI-Host": "judge0-ce.p.rapidapi.com"
    ]
    
    guard let url = URL(string: urlString) else {
        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
    let session = URLSession.shared
    session.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(nil, error)
            return
        }
        
        guard let data = data,
              var json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                  completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"]))
                  return
              }
        json.reverse()
        
        // Loop through each language in the response to find if language name is contained
        if let language = json.first(where: {
            if let name = $0["name"] as? String {
                return name.contains(languageName)
            }
            return false
        }) {
            completion(language["id"] as? Int, nil)
        } else {
            completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Language not found"]))
        }
    }.resume()
}

// Example usage


//fetchLanguageId(for: "Python") { id, error in
//    if let id = id {
//        print("Language ID for Python: \(id)")
//    } else if let error = error {
//        print("An error occurred: \(error.localizedDescription)")
//    }
//}


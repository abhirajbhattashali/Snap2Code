//
//  Compiler.swift
//  GenerativeAICompiler
//
//  Created by Abhiraj on 01/01/24.
//


import Foundation

func executeCodeAndFetchResult(langId:Int,code:String,completion: @escaping (String?, Error?) -> Void) {
    guard let submissionURL = URL(string: "https://judge0-ce.p.rapidapi.com/submissions") else {
        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid submission URL"]))
        return
    }
    
    var request = URLRequest(url: submissionURL)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("136b3ee2bemsh702a58d48ad0552p179ca8jsnebcc3300f5df", forHTTPHeaderField: "X-RapidAPI-Key")
    request.addValue("judge0-ce.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
    
    let payload: [String: Any] = [
        "language_id":langId,
        "source_code":code,
        "stdin": ""
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
    
    let session = URLSession.shared
    let submissionTask = session.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(nil, error)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201,
              let data = data,
              let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let token = jsonData["token"] as? String else {
                  completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to submit code or parse response"]))
                  return
              }
        
        // Fetch the result using the token
        fetchResult(token: token, session: session, completion: completion)
    }
    submissionTask.resume()
}

func fetchResult(token: String, session: URLSession, completion: @escaping (String?, Error?) -> Void) {
    guard let resultURL = URL(string: "https://judge0-ce.p.rapidapi.com/submissions/\(token)?base64_encoded=false") else {
        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid result URL"]))
        return
    }
    
    var resultRequest = URLRequest(url: resultURL)
    resultRequest.addValue("136b3ee2bemsh702a58d48ad0552p179ca8jsnebcc3300f5df", forHTTPHeaderField: "X-RapidAPI-Key")
    resultRequest.addValue("judge0-ce.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
    
    let resultTask = session.dataTask(with: resultRequest) { resultData, _, error in
        if let error = error {
            completion(nil, error)
            return
        }
        
        guard let resultData = resultData,
              let json = try? JSONSerialization.jsonObject(with: resultData) as? [String: Any],
              let output = json["stdout"] as? String else {
                  completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch result or parse response"]))
                  return
              }
        
        // Return the output
        completion(output, nil)
    }
    resultTask.resume()
}

// Example usage

//executeCodeAndFetchResult { output, error in
//    DispatchQueue.main.async {
//        if let output = output {
//            print("Output: \(output)")
//        } else if let error = error {
//            print("Error: \(error.localizedDescription)")
//        }
//    }
//}
//
//

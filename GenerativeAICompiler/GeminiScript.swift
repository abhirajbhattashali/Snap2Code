//
//  GeminiScript.swift
//  GenerativeAICompiler
//
//  Created by Abhiraj on 01/01/24.
//

import Foundation
import GoogleGenerativeAI
import SwiftUI

func findProgLangFromCode(code:String) async -> String{
    let apiKey = "AIzaSyBIzo93N_J5tJ_oK9CDJPdTXl4gnWDdRAc"
    let model = GenerativeModel(name: "gemini-pro", apiKey: apiKey)
    let prompt = "Find the programming language from the source code: \(code)"
        
        do {
            let response = try await model.generateContent(prompt)
          if let text = response.text {
            return text
          } else {
            return "Language Unidentified"
          }
        } catch {
            if error.localizedDescription.lowercased().contains("network") {
            return "Poor Network"
          } else {
            return "Error"
          }
        }
    }
    
 
   



func extractCodeFromImg(from image:UIImage) async -> String{
    let apiKey = "AIzaSyBIzo93N_J5tJ_oK9CDJPdTXl4gnWDdRAc"
    let imageModel = GenerativeModel(name: "gemini-pro-vision", apiKey: apiKey)
    let prompt = "Extract the programming language source code from image and return it if it exists in the specified image , if no code is detected return 'no Source Code' , if language is not detected return 'Unknown' "
        
        do {
            let response = try await imageModel.generateContent(prompt,image)
          if let text = response.text {
            return text
          } else {
            return "No source code Detected"
          }
        } catch {
            if error.localizedDescription.lowercased().contains("network") {
            return "Poor Network"
          } else {
            return "Error"
          }
        }
    }
    
 
   




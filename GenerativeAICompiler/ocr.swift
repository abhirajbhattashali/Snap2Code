import UIKit
import Vision
import SwiftUI

func recognizeText(from image: UIImage) -> String {
    // Convert UIImage to CGImage
    guard let cgImage = image.cgImage else {
        return "Unable to create CGImage."
    }
    
    // Result string
    var recognizedText = ""
    
    // Create a request handler
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    
    // Create a text recognition request
    let request = VNRecognizeTextRequest { (request, error) in
        guard error == nil else {
            return
        }
        
        // Process the results
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        // Concatenate the recognized text from all the observations
        for observation in observations {
            guard let topCandidate = observation.topCandidates(1).first else {
                continue
            }
            recognizedText += topCandidate.string + "\n"
        }
    }
    
    // Perform the text recognition request
    do {
        try handler.perform([request])
    } catch {
        print("Error performing text recognition: \(error)")
    }
    
    return recognizedText
}


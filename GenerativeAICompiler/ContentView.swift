
import SwiftUI

struct ContentView: View {
    @State private var showImageView = false
    @State private var showOutputView = false
    @State private var image: UIImage = UIImage()
    @State private var recognizedText = ""
    @State private var langName = "Language"
    @State private var compiledOutput = "" // Placeholder for the compiled output

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 40/255, green: 44/255, blue: 52/255) // One Dark Theme Background
                    .ignoresSafeArea()
            
                VStack(spacing: 20) {
                    // Header with buttons and language text
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color(red: 56/255, green: 58/255, blue: 66/255))
                        .frame(height: 70)
                        .overlay(
                            HStack {
                                // Photo Selection Button
                                Button(action: {
                                    self.showImageView = true
                                }) {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color(red: 97/255, green: 175/255, blue: 239/255))
                                        .clipShape(Circle())
                                }
                                .padding(.leading, 10)

                                // Language Name Text
                                Text(langName)
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                                    .padding(.horizontal)

                                Spacer()

                                // Run Button
                                Button(action: {
                                    compileSourceCode()
                                }) {
                                    Image(systemName: "play.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.green)
                                }
                                .padding(.trailing, 10)
                            }
                            .padding(.horizontal)
                        )
                        .padding(.top, 30)

                    Spacer()

                    // TextEditor
                    TextEditor(text: $recognizedText)
                        .foregroundColor(.black)
                        .frame(height: 400)
                        .background(Color(red: 56/255, green: 58/255, blue: 66/255))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 97/255, green: 175/255, blue: 239/255), lineWidth: 2))
                        .padding()

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("AI IDE")
            .sheet(isPresented: $showImageView, onDismiss: loadImage) {
                ImagePicker(selectedImage: $image)
            }
            .sheet(isPresented: $showOutputView) {
                OutputView(compiledOutput: compiledOutput)
            }
        }
    }

    func recognizeLanguageFromImage() {
        DispatchQueue.main.async {
            Task {
                let result = await findProgLangFromCode(code: recognizedText)
                if result.lowercased() != "language unidentified" {
                    self.langName = result
                } else {
                    self.langName = "Language Unidentified"
                }
            }
        }
    }

    func compileSourceCode() {
        recognizeLanguageFromImage()
        
        fetchLanguageId(for:langName) { id, error in
            if let id = id {
                print(id,type(of: id))
                print(recognizedText)
                let trimmed = recognizedText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                print("-----------")
                print(trimmed)
                
                executeCodeAndFetchResult(langId:id,code:trimmed) { output, error in
                    DispatchQueue.main.async {
                        if let output = output {
                            
                            print("Output: \(output)")
                            compiledOutput = output
                            showOutputView = true
                        } else if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
            } else if let error = error {
                print("An error occurred: \(error.localizedDescription)")
            }
        }

       
    }

    func loadImage() {
        DispatchQueue.main.async {
            Task {
                let result = await extractCodeFromImg(from: self.image)
                if (result.lowercased() != "no source code detected" && result.lowercased() != "poor network" && result.lowercased() != "error") {
                    self.recognizedText = result
                    recognizeLanguageFromImage() 
                } else {
                    self.recognizedText = "Error or no source code detected."
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

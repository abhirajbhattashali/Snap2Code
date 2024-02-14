import SwiftUI

struct OutputView: View {
    let compiledOutput: String // This variable holds the content to be displayed

    var body: some View {
        ScrollView {
            Text(compiledOutput) // Ensure this text view uses compiledOutput
                .font(.system(.body, design: .monospaced))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.black)
                .foregroundColor(Color.green)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                .padding()
        }
        .background(Color(red: 30/255, green: 30/255, blue: 30/255))
        .navigationTitle("Compiled Output")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
  
        OutputView(compiledOutput: "print(\"Hello, World!\")\nHello, World!")
    }


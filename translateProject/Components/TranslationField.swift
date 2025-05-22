import SwiftUI

struct TranslationField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isEditable: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.gray)
                .font(.subheadline)
            
            TextEditor(text: isEditable ? $text : .constant(text))
                .frame(height: 100)
                .foregroundColor(.black) // 👈 Yazı rengi siyah
                .background(Color.theme.surface)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.05), radius: 3)
                .disabled(!isEditable)
            
            HStack {
                Text("\(text.count)/2300")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {}) {
                        Image(systemName: "link")
                            .foregroundColor(Color.theme.primary)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "speaker.wave.2")
                            .foregroundColor(Color.theme.primary)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}


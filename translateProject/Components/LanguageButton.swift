import SwiftUI

struct LanguageButton: View {
    let language: Language
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(language.flag)
                    .font(.title2)
                Text(language.name)
                    .foregroundColor(Color.theme.textPrimary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color.theme.primary)
            }
        }
            .padding()
        .background(Color.theme.surface)
            .cornerRadius(12)
        }
    }
}

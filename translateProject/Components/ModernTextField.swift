
import SwiftUI

struct ModernTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color.theme.primary)
                .frame(width: 44, height: 44)
                .padding(.leading, 8)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(Color.theme.textPrimary)
                    .autocapitalization(.none)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(Color.theme.textPrimary)
                    .autocapitalization(.none)
            }
        }
        .frame(height: 56)
        .background(Color.theme.surface)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 3)
        .padding(.horizontal)
    }
}

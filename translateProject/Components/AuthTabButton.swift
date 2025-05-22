import SwiftUI

struct AuthTabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isSelected ? Color.theme.textPrimary : Color.theme.textSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    ZStack {
                        if isSelected {
                            Color.theme.surface
                                .cornerRadius(12)
                        }
                    }
                )
        }
    }
}

import SwiftUI

struct TabButton: View {
    let icon: String
    let text: String
    let iconType: String
    
    var body: some View {
        VStack(spacing: 4) {
            if iconType == "mic" {
                Image(systemName: icon)
                    .font(.system(size: 20))
            } else if iconType == "text" {
                Text("Text")
                    .font(.system(size: 16, weight: .medium))
            } else {
                Image(systemName: icon)
                    .font(.system(size: 20))
            }
            
            Text(text)
                .font(.caption)
        }
        .foregroundColor(Color.theme.textSecondary)
        .frame(maxWidth: .infinity)
    }
}

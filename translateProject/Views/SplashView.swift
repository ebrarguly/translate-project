import SwiftUI

struct SplashView: View {
    @State private var progress: Double = 0
    @State private var isActive: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image("world_flags")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.theme.primary, lineWidth: 4)
                    )
                
                Text("Dünyanın 98'den fazla dilinin çevirisi")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("Uygulamamızda, tüm metinlerinizi 98 yaşayan dile herhangi bir sorun veya eksiklik olmadan çevirebilirsiniz.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.theme.textSecondary)
                    .padding(.horizontal)
                
                // İlerleme çubuğu
                ProgressView(value: progress, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.theme.primary))
                    .padding(.horizontal)
            }
        }
        .onAppear {
            // Animasyonlu ilerleme
            withAnimation(.easeInOut(duration: 2)) {
                progress = 100
            }
            
            // 2 saniye sonra AuthView'a geçiş
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isActive = true
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            AuthView()
        }
    }
}

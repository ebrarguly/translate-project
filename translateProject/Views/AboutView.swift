import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Üst başlık
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundColor(Color.theme.textPrimary)
                                .font(.title2)
                        }
                        
                        Spacer()
                        
                        Text("Hakkında")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.theme.textPrimary)
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.theme.surface)
                    
                    ScrollView {
                        VStack(spacing: 32) {
                            // Logo ve Uygulama Adı
                            VStack(spacing: 16) {
                                Image("world_flags")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.theme.primary, lineWidth: 2)
                                    )
                                
                                Text("Çeviri Uygulaması")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.theme.textPrimary)
                                
                                Text("Versiyon 1.0.0")
                                    .font(.subheadline)
                                    .foregroundColor(Color.theme.textSecondary)
                            }
                            .padding(.top, 20)
                            
                            // Uygulama Açıklaması
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Uygulama Hakkında")
                                    .font(.headline)
                                    .foregroundColor(Color.theme.textPrimary)
                                
                                Text("Çeviri Uygulaması, 98'den fazla dil arasında anlık çeviri yapmanızı sağlayan kullanıcı dostu bir uygulamadır. Metin çevirisi, sesli çeviri ve favorilere ekleme özellikleriyle dil engelini ortadan kaldırmayı amaçlıyoruz.")
                                    .font(.body)
                                    .foregroundColor(Color.theme.textSecondary)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.horizontal)
                            
                            // Özellikler
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Özellikler")
                                    .font(.headline)
                                    .foregroundColor(Color.theme.textPrimary)
                                
                                FeatureRow(icon: "text.bubble.fill", title: "Metin Çeviri", description: "98+ dil arasında anlık metin çevirisi")
                                FeatureRow(icon: "mic.fill", title: "Sesli Çeviri", description: "Konuşarak anlık çeviri yapabilme")
                                FeatureRow(icon: "star.fill", title: "Favoriler", description: "Sık kullanılan çevirileri kaydetme")
                                FeatureRow(icon: "clock.fill", title: "Geçmiş", description: "Geçmiş çevirilere erişim")
                            }
                            .padding(.horizontal)
                            
                            // İletişim Bilgileri
                            VStack(alignment: .leading, spacing: 16) {
                                Text("İletişim")
                                    .font(.headline)
                                    .foregroundColor(Color.theme.textPrimary)
                                
                                ContactRow(icon: "envelope.fill", title: "E-posta", value: "iletisim@translateapp.com")
                                ContactRow(icon: "globe", title: "Website", value: "www.translateapp.com")
                                ContactRow(icon: "phone.fill", title: "Telefon", value: "+90 555 123 4567")
                            }
                            .padding(.horizontal)
                            
                            // Sosyal Medya
                            VStack(spacing: 16) {
                                Text("Bizi Takip Edin")
                                    .font(.headline)
                                    .foregroundColor(Color.theme.textPrimary)
                                
                                HStack(spacing: 20) {
                                    SocialButton(icon: "x.circle.fill", action: {})
                                    SocialButton(icon: "link.circle.fill", action: {})
                                    SocialButton(icon: "message.circle.fill", action: {})
                                    SocialButton(icon: "envelope.circle.fill", action: {})
                                }
                            }
                            .padding(.top)
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color.theme.primary)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.textPrimary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(Color.theme.textSecondary)
            }
        }
        .padding()
        .background(Color.theme.surface)
        .cornerRadius(12)
    }
}

struct ContactRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color.theme.primary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Color.theme.textSecondary)
                
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(Color.theme.textPrimary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.theme.surface)
        .cornerRadius(12)
    }
}

struct SocialButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(Color.theme.primary)
        }
    }
} 

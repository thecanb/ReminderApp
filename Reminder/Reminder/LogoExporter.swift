import SwiftUI

@MainActor
struct LogoExporter {
    static func exportLogo() async {
        let size: CGFloat = 1024 // App Store için gereken boyut
        
        let logo = LogoView()
            .frame(width: size, height: size)
        
        let renderer = ImageRenderer(content: logo)
        
        // Ekran ölçeğini 1 olarak ayarla (1024x1024 için)
        renderer.scale = 1.0
        
        if let image = renderer.uiImage {
            if let data = image.pngData() {
                let filename = getDocumentsDirectory().appendingPathComponent("AppIcon.png")
                try? data.write(to: filename)
                print("Logo kaydedildi: \(filename)")
            }
        }
    }
    
    static func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

#Preview {
    LogoView()
        .frame(width: 200, height: 200)
        .task {
            await LogoExporter.exportLogo()
        }
}

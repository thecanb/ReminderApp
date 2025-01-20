import Foundation

extension String {
    func extractAmount() -> String? {
        // Basit bir regex ile fiyat çıkarma
        let pattern = #"(\d+[.,]\d{2})"#
        if let range = self.range(of: pattern, options: .regularExpression) {
            return String(self[range])
        }
        return nil
    }
    
    func extractDate() -> Date? {
        // Tarih formatları
        let dateFormatter = DateFormatter()
        let formats = ["dd.MM.yyyy", "dd/MM/yyyy", "yyyy-MM-dd"]
        
        for format in formats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: self) {
                return date
            }
        }
        return nil
    }
}

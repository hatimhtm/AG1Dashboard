//
//  CSVParser.swift
//  AG1Dashboard
//
//  Utility for parsing the AG1-Data.csv file
//

import Foundation

// MARK: - Parser Errors
enum CSVParserError: Error, LocalizedError {
    case fileNotFound
    case invalidFormat
    case parsingError(line: Int, column: String)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Le fichier CSV n'a pas été trouvé"
        case .invalidFormat:
            return "Format CSV invalide"
        case .parsingError(let line, let column):
            return "Erreur ligne \(line), colonne: \(column)"
        }
    }
}

// MARK: - CSV Parser
struct CSVParser {
    
    /// Parses the CSV file from the app bundle
    static func parseCreatives(from filename: String) throws -> [Creative] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "csv") else {
            throw CSVParserError.fileNotFound
        }
        
        let content = try String(contentsOf: url, encoding: .utf8)
        return try parseCSVContent(content)
    }
    
    /// Parses CSV content string into Creative objects
    static func parseCSVContent(_ content: String) throws -> [Creative] {
        var creatives: [Creative] = []
        
        let lines = content
            .components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        guard lines.count > 1 else {
            throw CSVParserError.invalidFormat
        }
        
        // Build column index map from header
        let headers = parseCSVLine(lines[0])
        let columnMap = Dictionary(uniqueKeysWithValues: headers.enumerated().map { ($1, $0) })
        
        // Parse each data row
        for (index, line) in lines.dropFirst().enumerated() {
            let values = parseCSVLine(line)
            
            guard values.count >= headers.count else { continue }
            
            if let creative = parseCreative(from: values, columnMap: columnMap) {
                creatives.append(creative)
            }
        }
        
        return creatives
    }
    
    /// Parses a single CSV line, handling quoted values
    private static func parseCSVLine(_ line: String) -> [String] {
        var result: [String] = []
        var current = ""
        var inQuotes = false
        
        for char in line {
            if char == "\"" {
                inQuotes.toggle()
            } else if char == "," && !inQuotes {
                result.append(current.trimmingCharacters(in: .whitespaces))
                current = ""
            } else {
                current.append(char)
            }
        }
        result.append(current.trimmingCharacters(in: .whitespaces))
        
        return result
    }
    
    /// Converts a row of values into a Creative object
    private static func parseCreative(from values: [String], columnMap: [String: Int]) -> Creative? {
        
        func get(_ column: String) -> String {
            guard let idx = columnMap[column], idx < values.count else { return "" }
            return values[idx]
        }
        
        func getDouble(_ column: String) -> Double {
            let val = get(column)
                .replacingOccurrences(of: ",", with: ".")
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "€", with: "")
                .replacingOccurrences(of: "%", with: "")
            return Double(val) ?? 0.0
        }
        
        func getInt(_ column: String) -> Int {
            let val = get(column).replacingOccurrences(of: " ", with: "")
            return Int(val) ?? 0
        }
        
        // Parse launch date
        var launchDate: Date? = nil
        let dateStr = get("Date de lancement")
        if !dateStr.isEmpty {
            let fmt = DateFormatter()
            fmt.dateFormat = "dd/MM/yyyy"
            launchDate = fmt.date(from: dateStr)
        }
        
        return Creative(
            adName: get("Nom de l'annonce"),
            product: get("Produit"),
            creator: get("Créateur"),
            contentType: get("Type de contenu"),
            marketingAngle: get("Angle marketing"),
            hook: get("Hook"),
            month: get("Mois"),
            status: get("Statut"),
            launchDate: launchDate,
            budget: getDouble("Budget dépensé (€)"),
            conversions: getInt("Conversions (achats)"),
            revenue: getDouble("Revenu estimé (€)"),
            roas: getDouble("ROAS"),
            costPerConversion: getDouble("Coût par conversion (€)"),
            impressions: getInt("Impressions"),
            clicks: getInt("Clics"),
            clickRate: getDouble("Taux de clic (%)")
        )
    }
}

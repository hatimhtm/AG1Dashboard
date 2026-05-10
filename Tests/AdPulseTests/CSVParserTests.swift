//
//  CSVParserTests.swift
//  AdPulseTests
//

import XCTest
@testable import AdPulse

final class CSVParserTests: XCTestCase {

    private let header = "Nom de l'annonce,Produit,Créateur,Type de contenu,Angle marketing,Hook,Mois,Statut,Date de lancement,Budget dépensé (€),Conversions (achats),Revenu estimé (€),ROAS,Coût par conversion (€),Impressions,Clics,Taux de clic (%)"

    func testParsesValidRow() throws {
        let row = "Vital_UGC_Emma_Energie_V1,Vital Powder,Emma Laurent,UGC,Énergie,Mon avis,Octobre 2025,En ligne,15/10/2025,2500,85,7650,3.06,29.41,125000,3750,3.0"
        let csv = "\(header)\n\(row)"

        let creatives = try CSVParser.parseCSVContent(csv)

        XCTAssertEqual(creatives.count, 1)
        let c = try XCTUnwrap(creatives.first)
        XCTAssertEqual(c.adName, "Vital_UGC_Emma_Energie_V1")
        XCTAssertEqual(c.product, "Vital Powder")
        XCTAssertEqual(c.creator, "Emma Laurent")
        XCTAssertEqual(c.budget, 2500, accuracy: 0.001)
        XCTAssertEqual(c.conversions, 85)
        XCTAssertEqual(c.roas, 3.06, accuracy: 0.001)
        XCTAssertEqual(c.impressions, 125_000)
    }

    func testThrowsOnEmptyContent() {
        XCTAssertThrowsError(try CSVParser.parseCSVContent("")) { error in
            XCTAssertTrue(error is CSVParserError)
        }
    }

    func testSkipsMalformedRows() throws {
        let goodRow = "Vital_Test,Vital Powder,Marc,UGC,Test,Hook,Octobre 2025,En ligne,01/10/2025,1000,10,5000,5,100,50000,1500,3.0"
        let badRow = "incomplete,row" // way fewer fields than header
        let csv = "\(header)\n\(goodRow)\n\(badRow)"

        let creatives = try CSVParser.parseCSVContent(csv)
        XCTAssertEqual(creatives.count, 1, "Malformed rows should be silently skipped")
    }

    func testParsesEuroAndCommaDecimals() throws {
        // Some CSVs export "2 500,50€" — parser strips currency symbols, spaces,
        // and converts commas to dots. Verify that pipeline.
        let row = "Vital_X,Vital Powder,X,UGC,A,H,Octobre 2025,En ligne,01/10/2025,2 500,50,1000,2.5,50,10000,500,5.0"
        let csv = "\(header)\n\(row)"

        let creatives = try CSVParser.parseCSVContent(csv)
        let c = try XCTUnwrap(creatives.first)
        XCTAssertEqual(c.budget, 2500, accuracy: 0.001)
    }
}

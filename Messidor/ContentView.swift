//
//  ContentView.swift
//  Messidor
//
//  Created by patrick philipot on 13/06/2020.
//  Copyright © 2020 stgpcs. All rights reserved.
//

import SwiftUI
import Combine

class ViewModel: ObservableObject {
    let cnv = RomanConversion()
    var year : Int = 0
    
    @Published var annee: String = "2020"{
        didSet {
            year = Int(annee) ?? 0
            romanAnnee = year >= 3999 ? "ERR" : cnv.convert(intToRoman: year)
        }
    }
    
    @Published var romanAnnee: String = "MMXX"
    
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    var romanAnnee = "MMXX"
    let date = Date()
    let cal = CalendrierRevolutionnaire()
    // test values
    @State var allLines = [String]()
    @State var line1 : String = "non disponible"
    
    var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }
    
    func loadTestFile() {
        if let testFileURL = Bundle.main.url(forResource: "testFile", withExtension: "txt") {
            if let lines = try? String(contentsOf: testFileURL) {
                allLines = lines.components(separatedBy: "\r\n")
            }
        }

        if allLines.isEmpty {
            allLines = ["error"]
        }
        
        for n in 0..<allLines.count {
            print(n)
            checkLine(line: allLines[n])
        }
    }
    
    func checkLine( line: String) {
        // line est composée de 2 parties séparées par @
        // ex: 11-01-1959@21 Nivôse de l'an CLXVII
        // partie 1 = date au format JJ-MM-AAAA
        // partie 2 = date dans le calendrier révolutionnaire
        // la fonction vérifie qu'elles correspondent
        
        // extraction des deux parties
        let parties : [String] = line.components(separatedBy: "@")

        // décomposition de partie 1 = date au format JJ-MM-AAAA
        let dateJMAComponents : [String] = parties[0].components(separatedBy: "-")
        let sj : Int = Int(dateJMAComponents[0]) ?? 22
        let sm : Int = Int(dateJMAComponents[1]) ?? 9
        let sa : Int = Int(dateJMAComponents[2]) ?? 1792
        
        // converion en date du calendier révolutionnaire
        
        let dateTest = cal.nouvelleDateAvec(jour: sj, mois: sm, annee: sa)
        let dateConvertie = cal.dateRepublicaine(pourDateGregorienne: dateTest, avecNomDuJour: false)
        
        // partie 2 = date dans le calendrier révolutionnaire
        let expectedResult = parties[1]
        
        assert(dateConvertie == expectedResult, "Erreur avec \(dateConvertie) <> \(expectedResult)")
    }
    
    var body: some View {
        let nomDuJour : String = cal.dateRepublicaine(pourDateGregorienne: date, avecNomDuJour: true).components(separatedBy: "@")[1]
                                  
        Form {
        Text("\( dateFormatter.string(from: date))")
            .padding()
        Text("\(cal.dateRepublicaine(pourDateGregorienne: date, avecNomDuJour: false))")
            .padding()
        Text("\(nomDuJour)")
                .padding()

        Button(action: {
            self.loadTestFile()
        }) { Text("Test")}
        } // form
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

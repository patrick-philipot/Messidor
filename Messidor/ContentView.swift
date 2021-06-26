//
//  ContentView.swift
//  Messidor
//
//  Created by patrick philipot on 13/06/2020.
//  Copyright © 2020 stgpcs. All rights reserved.
//  pushed on GitHub

import SwiftUI
import Combine


struct ContentView: View {
    @State private var date = Date()
    
    let cal = CalendrierRevolutionnaire()
    
    var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }
    
    // MARK bug here - la date est fausse
    var body: some View {
        let nomDuJour : String = cal.dateRepublicaine(pourDateGregorienne: date, avecNomDuJour: true).components(separatedBy: "@")[1]
                                  
        Form {
        Text("\( dateFormatter.string(from: date))")
            .padding()
        Text("\(cal.dateRepublicaine(pourDateGregorienne: date, avecNomDuJour: false))")
            .padding()
        Text("\(nomDuJour)")
                .padding()
        } // form
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  calendrierRevolutionnaire.swift
//  Equinoxe
//
//  Created by patrick philipot on 11/06/2020.
//  Copyright © 2020 stgpcs. All rights reserved.
//

import Foundation

struct CalendrierRevolutionnaire {
    let calendar = Calendar(identifier: .gregorian)
    let cnv = RomanConversion()
    
    func daysBetween(start: Date, end: Date) -> Int {
        return Int(start.timeIntervalSince(end) / (24*60*60))
    }

    func nouvelleDateAvec(jour dd: Int, mois mm: Int, annee yyyy:Int) -> Date {
        func complete(_ n: Int) -> String {
            let s = String(n)
            return n < 9 ? "0"+s : s
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let isoDate = "\(yyyy)-\(complete(mm))-\(complete(dd))T12:00:00+0000"
        return dateFormatter.date(from: isoDate)!
    }

    func jour1erVendemiaire(pourAnnee yyyy: Int) -> Date {
        let arrayIndex = yyyy - 1792 // + 1
        let quantieme = 20 + arrayJ1V[arrayIndex]
        return nouvelleDateAvec(jour: quantieme, mois: 9, annee: yyyy)
    }

    func nomJourRepublicain(nbJoursDepuis1erVendemiaire nbj: Int)-> String {
        // nbj est compris entre 1 et 366
        // retourne le jour, exemple : "1er Vendémiaire"
        let p = Int((nbj - 1) / 30)
//        print("p \(p)")
        let j = nbj - (p * 30)
        let s:String = (p == 12) ? "ème " : " "
        let sFinal: String = "\(j)\((j == 1) ? "er " : s)\(arrayNomMois[p])"

        return sFinal
    }

    func dateRepublicaine(pourDateGregorienne date: Date, avecNomDuJour : Bool) -> String {
        // retourne une date révolutionnaire
        // exemple : 26 aout 2013 => 9 fructidor 221
        // il faut distinguer 2 cas :
        // avec DAC, la date à convertir, J1V, le 1er Vendémiaire
        // a) - - - - - - - - - - - - (J1V) - - - - - - - - DAC - - - - (DAC > J1V dans année courante)
        // b) - - - -  DAC- - - - - - (J1V) - - - - - - - - - - - - - - (DAC < J1V dans année courante)
        
        var anneeBase: Int = calendar.component(.year, from: date)
        if jour1erVendemiaire(pourAnnee: anneeBase) > date {
            anneeBase -= 1
        }
    //  print("anneeBase \(anneeBase)")
        let j1V = jour1erVendemiaire(pourAnnee: anneeBase)
//        print("j1V \(j1V)")
        let anneeRepublicaine = anneeBase - 1792 + 1
//        print("anneeRepublicaine \(anneeRepublicaine)")
        let nbJours = abs(daysBetween(start: j1V, end: date)) + 1
//        print("nbJours \(nbJours)")
        let dateSimple = nomJourRepublicain(nbJoursDepuis1erVendemiaire: nbJours) + " de l'an " + cnv.convert(intToRoman: anneeRepublicaine)
        let nomDuJour = arrayNomJour[nbJours - 1]
        return avecNomDuJour ? "\(dateSimple)@\(nomDuJour)" : "\(dateSimple)"
    }
    
}

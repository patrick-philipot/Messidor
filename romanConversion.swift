//
//  romanConversion.swift
//  Equinoxe
//
//  Created by patrick philipot on 17/05/2020.
//  Copyright © 2020 stgpcs. All rights reserved.
//

import Foundation

struct RomanConversion {
    let lookup = [(roman: "M", arabic: 1000), (roman: "CM", arabic: 900), (roman: "D", arabic: 500), (roman: "CD", arabic: 400), (roman: "C", arabic: 100), (roman: "XC", arabic: 90), (roman: "L", arabic: 50), (roman: "XL", arabic: 40), (roman: "X", arabic: 10), (roman: "IX", arabic: 9), (roman: "V", arabic: 5), (roman: "IV", arabic: 4), (roman: "I", arabic: 1)]
    
    func convert(intToRoman n: Int) -> String {
        var roman : String = ""
        var num = n
        
        for i in self.lookup {
            while ( num >= i.arabic ) {
                roman += i.roman
                num -= i.arabic;
            }
        }
        return roman
    }
    
    // transforme un nombre romain, par exemple CCXXIV
    // en nombres classiques (avec des chiffres arabes)
    func convert(romanToInt romanString: String ) -> Int {
        var roman = romanString
        var n : Int = 0
        
        for item in self.lookup {
            let romanToken = item.roman
            while roman.starts(with: romanToken) {
                n += item.arabic
                roman.removeFirst(romanToken.count)
            }
        }
        return n
    }
}

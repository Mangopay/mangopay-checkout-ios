//
//  File.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import Foundation


class Utils {
    
    var countries: [Country] = []
    
    func loadCountries() {
        let queue = DispatchQueue(label: "CountryLoaderQueue", qos: .background)
        queue.async {
            
            guard let url = Bundle.module.url(
                forResource: "countrylistdata",
                withExtension: "json"
            ) else {
                print("failed to recover ❌")
                print("bundle", Bundle.module)
                return
                
            }

            do {
                let decoder = JSONDecoder()
                let data = try Data(contentsOf: url)
                let countries = try decoder.decode([Country].self, from: data)
                self.countries = countries.filter{$0.dialCode != ""}
            } catch let err {
                print("Error occurred whiles decoding: \(err.localizedDescription)")
            }
        }
    }
    
}

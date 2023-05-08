//
//  File.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import Foundation


class Utils {
        
    func loadCountries(
         onSuccess: @escaping ([Country]) -> (),
        onFailure: @escaping () -> ()
    ) {
        let queue = DispatchQueue(label: "CountryLoaderQueue", qos: .background)
        queue.async {
            
            guard let url = Bundle.module.url(
                forResource: "countrylistdata",
                withExtension: "json"
            ) else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let data = try Data(contentsOf: url)
                let countries = try decoder.decode([Country].self, from: data)
                DispatchQueue.main.async {
                    onSuccess(countries)
                }
            } catch let err {
                print("Error occurred whiles decoding: \(err.localizedDescription)")
                DispatchQueue.main.async {
                    onFailure()
                }
            }
        }
    }
    
}

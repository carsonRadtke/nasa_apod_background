//
//  main.swift
//  nasa_apod_background
//
//  Created by Carson Radtke on 6/28/21.
//

import Foundation

let endpoint: String = "https://api.nasa.gov"
let apiKey: String = "<REDACTED>" // use 'DEMO_KEY' for testing

func getImageData() -> APODObject? {
    
    return nil
    
}

func getImage(apod: APODObject?) -> String? {
   
    if apod == nil {
        return nil
    }
    
    return nil
    
}

func setBackground(img: Any?) -> Void {
    
    if img == nil {
        return
    }
    
}

func main() {
    
    setBackground(img: getImage(apod: getImageData()))
    
}

main()

struct APODObject {
    var copyright: String? = nil
    var date: String? = nil
    var explanation: String? = nil
    var hdurl: String? = nil
    var media_type: String? = nil
    var service_version: String? = nil
    var title: String? = nil
    var url: String? = nil
}

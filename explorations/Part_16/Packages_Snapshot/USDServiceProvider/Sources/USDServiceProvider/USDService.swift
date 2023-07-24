//
//  USDService.swift
//  
//
//  Created by Carlyn Maw on 7/23/23.
//

import Foundation


protocol USDService {
    func makeCrate(from inputFile:String, outputFile:String) -> String
    func check(_ inputFile:String) -> String
}

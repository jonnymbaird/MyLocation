//
//  String+AddText.swift
//  MyLocation
//
//  Created by Jonathan Baird  on 17/08/2020.
//  Copyright © 2020 Jonathan Baird . All rights reserved.
//

import Foundation

extension String {
    mutating func add(text: String?, separatedBy seperator: String = "") {
        if let text = text {
            if !isEmpty {
                self += seperator
            }
            self += text
        }
    }
}

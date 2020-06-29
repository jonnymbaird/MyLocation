//
//  Functions.swift
//  MyLocation
//
//  Created by Jonathan Baird  on 28/06/2020.
//  Copyright © 2020 Jonathan Baird . All rights reserved.
//

import Foundation

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds,
                                  execute: run)
}

let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}()

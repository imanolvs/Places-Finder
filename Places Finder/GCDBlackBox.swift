//
//  GCDBlackBox.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 10/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void ) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}
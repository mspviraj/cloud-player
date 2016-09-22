//
//  ActionState.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 15/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation

enum ActionState: Int {
    case NoAction = 0
    case PendingToDownload = 1
    case PendingToRemoval = 2
}
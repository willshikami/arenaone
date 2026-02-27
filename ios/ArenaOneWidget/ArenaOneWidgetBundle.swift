//
//  ArenaOneWidgetBundle.swift
//  ArenaOneWidget
//
//  Created by Donator on 26/02/2026.
//

import WidgetKit
import SwiftUI

@main
struct ArenaOneWidgetBundle: WidgetBundle {
    var body: some Widget {
        ArenaOneWidget()
        ArenaOneWidgetControl()
        ArenaOneWidgetLiveActivity()
    }
}

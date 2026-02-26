//
//  ArenaOneWidgetLiveActivity.swift
//  ArenaOneWidget
//
//  Created by Donator on 26/02/2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ArenaOneWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ArenaOneWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ArenaOneWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ArenaOneWidgetAttributes {
    fileprivate static var preview: ArenaOneWidgetAttributes {
        ArenaOneWidgetAttributes(name: "World")
    }
}

extension ArenaOneWidgetAttributes.ContentState {
    fileprivate static var smiley: ArenaOneWidgetAttributes.ContentState {
        ArenaOneWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ArenaOneWidgetAttributes.ContentState {
         ArenaOneWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ArenaOneWidgetAttributes.preview) {
   ArenaOneWidgetLiveActivity()
} contentStates: {
    ArenaOneWidgetAttributes.ContentState.smiley
    ArenaOneWidgetAttributes.ContentState.starEyes
}

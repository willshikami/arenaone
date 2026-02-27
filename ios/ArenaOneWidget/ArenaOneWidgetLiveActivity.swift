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
        var status: String
        var score: String
        var team_a: String
        var team_b: String
        var title: String
        var sport: String
        var game_id: String
    }
}

struct ArenaOneWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ArenaOneWidgetAttributes.self) { context in
            // Lock screen/banner UI
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(context.state.title)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(context.state.sport)
                        .font(.system(size: 8, weight: .black))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.2))
                        .foregroundColor(.orange)
                        .cornerRadius(4)
                }
                
                HStack {
                    Text(context.state.team_a)
                        .font(.headline)
                        .bold()
                    
                    Spacer()
                    
                    Text(context.state.score)
                        .font(.title2)
                        .bold()
                        .monospacedDigit()
                    
                    Spacer()
                    
                    Text(context.state.team_b)
                        .font(.headline)
                        .bold()
                }
                
                Text(context.state.status)
                    .font(.caption2)
                    .foregroundColor(context.state.status.uppercased().contains("LIVE") ? .red : .gray)
                    .bold()
            }
            .padding()
            .activityBackgroundTint(Color(red: 0.05, green: 0.05, blue: 0.07))
            .activitySystemActionForegroundColor(Color.white)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.team_a)
                        .font(.title3)
                        .bold()
                        .padding(.leading, 8)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.team_b)
                        .font(.title3)
                        .bold()
                        .padding(.trailing, 8)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.score)
                        .font(.title)
                        .bold()
                        .monospacedDigit()
                        .foregroundColor(.orange)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 4) {
                        Text(context.state.title)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(context.state.status)
                            .font(.caption2)
                            .foregroundColor(context.state.status.uppercased().contains("LIVE") ? .red : .gray)
                            .bold()
                    }
                }
            } compactLeading: {
                Text(context.state.team_a)
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.gray)
            } compactTrailing: {
                Text(context.state.score)
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.orange)
            } minimal: {
                Text(context.state.score.contains("-") ? context.state.score.split(separator: "-").first?.trimmingCharacters(in: .whitespaces) ?? "" : "...")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.orange)
            }
            .keylineTint(Color.orange)
        }
    }
}

extension ArenaOneWidgetAttributes {
    fileprivate static var preview: ArenaOneWidgetAttributes {
        ArenaOneWidgetAttributes()
    }
}

extension ArenaOneWidgetAttributes.ContentState {
    fileprivate static var dummy: ArenaOneWidgetAttributes.ContentState {
        ArenaOneWidgetAttributes.ContentState(
            status: "LIVE - 4TH QTR",
            score: "102 - 98",
            team_a: "LAK",
            team_b: "GSW",
            title: "Lakers vs Warriors",
            sport: "BASKETBALL",
            game_id: "preview_game_123"
        )
     }
}

#Preview("Live Activity Header", as: .content, using: ArenaOneWidgetAttributes.preview) {
   ArenaOneWidgetLiveActivity()
} contentStates: {
    ArenaOneWidgetAttributes.ContentState.dummy
}

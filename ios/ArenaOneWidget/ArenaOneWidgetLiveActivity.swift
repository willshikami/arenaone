import ActivityKit
import SwiftUI
import WidgetKit

enum ArenaOneLiveActivityConstants {
    static let appGroupId = "group.com.opus.arenaone"
}

struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
    public typealias LiveDeliveryData = ContentState

    public struct ContentState: Codable, Hashable {
        var appGroupId: String
    }

    var id = UUID()
}

extension LiveActivitiesAppAttributes {
    func prefixedKey(_ key: String) -> String {
        "\(id)_\(key)"
    }
}

@available(iOSApplicationExtension 16.1, *)
struct ArenaOneWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
            let data = ArenaOneLiveActivityData(context: context)

            ArenaOneLockScreenLiveActivityView(data: data)
                .activityBackgroundTint(Color(red: 0.05, green: 0.05, blue: 0.07))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            let data = ArenaOneLiveActivityData(context: context)

            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    ArenaOneDynamicIslandTeamView(
                        title: data.teamA,
                        subtitle: data.teamADetail,
                        alignment: .leading
                    )
                }

                DynamicIslandExpandedRegion(.trailing) {
                    ArenaOneDynamicIslandTeamView(
                        title: data.teamB,
                        subtitle: data.teamBDetail,
                        alignment: .trailing
                    )
                }

                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 4) {
                        Text(data.score)
                            .font(.title3)
                            .fontWeight(.black)
                            .monospacedDigit()
                            .foregroundStyle(.orange)

                        Text(data.sport.uppercased())
                            .font(.system(size: 9, weight: .black, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }

                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 3) {
                        Text(data.title)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .lineLimit(1)

                        Text(data.status.uppercased())
                            .font(.caption2)
                            .fontWeight(.black)
                            .foregroundStyle(data.isLive ? .red : .secondary)
                    }
                }
            } compactLeading: {
                Text(data.teamA.prefix(3).uppercased())
                    .font(.caption2)
                    .fontWeight(.black)
                    .foregroundStyle(.secondary)
            } compactTrailing: {
                Text(data.score)
                    .font(.caption2)
                    .fontWeight(.black)
                    .monospacedDigit()
                    .foregroundStyle(.orange)
            } minimal: {
                Text(data.sport.prefix(2).uppercased())
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .foregroundStyle(.orange)
            }
            .keylineTint(.orange)
        }
    }
}

@available(iOSApplicationExtension 16.1, *)
struct ArenaOneLiveActivityData {
    let gameId: String
    let title: String
    let status: String
    let score: String
    let teamA: String
    let teamB: String
    let teamADetail: String
    let teamBDetail: String
    let sport: String
    let footer: String

    var isLive: Bool {
        status.localizedCaseInsensitiveContains("live") ||
            status.localizedCaseInsensitiveContains("thru")
    }

    init(context: ActivityViewContext<LiveActivitiesAppAttributes>) {
        let defaults = UserDefaults(suiteName: context.state.appGroupId)
            ?? UserDefaults(suiteName: ArenaOneLiveActivityConstants.appGroupId)
            ?? .standard

        func value(_ key: String, fallback: String) -> String {
            let prefixedKey = context.attributes.prefixedKey(key)
            let stringValue = defaults.string(forKey: prefixedKey)
            return stringValue?.isEmpty == false ? stringValue! : fallback
        }

        gameId = value("game_id", fallback: "")
        title = value("title", fallback: "Arena One")
        status = value("status", fallback: "Live")
        score = value("score", fallback: "LIVE")
        teamA = value("team_a", fallback: "Arena")
        teamB = value("team_b", fallback: "One")
        teamADetail = value("team_a_detail", fallback: "")
        teamBDetail = value("team_b_detail", fallback: "")
        sport = value("sport", fallback: "Sports")
        footer = value("footer", fallback: "")
    }
}

@available(iOSApplicationExtension 16.1, *)
struct ArenaOneLockScreenLiveActivityView: View {
    let data: ArenaOneLiveActivityData

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(data.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)

                    if !data.footer.isEmpty {
                        Text(data.footer)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer()

                Text(data.sport.uppercased())
                    .font(.system(size: 9, weight: .black, design: .rounded))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
                    .background(.orange.opacity(0.18), in: Capsule())
                    .foregroundStyle(.orange)
            }

            HStack(alignment: .center, spacing: 12) {
                ArenaOneLockScreenTeamView(title: data.teamA, subtitle: data.teamADetail)

                Spacer(minLength: 8)

                Text(data.score)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Spacer(minLength: 8)

                ArenaOneLockScreenTeamView(title: data.teamB, subtitle: data.teamBDetail)
                    .multilineTextAlignment(.trailing)
            }

            HStack(spacing: 6) {
                Circle()
                    .fill(data.isLive ? .red : .secondary)
                    .frame(width: 6, height: 6)

                Text(data.status.uppercased())
                    .font(.caption2)
                    .fontWeight(.black)
                    .foregroundStyle(data.isLive ? .red : .secondary)
                    .lineLimit(1)
            }
        }
        .padding()
    }
}

@available(iOSApplicationExtension 16.1, *)
struct ArenaOneLockScreenTeamView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.headline)
                .fontWeight(.black)
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.65)

            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: 96, alignment: .leading)
    }
}

@available(iOSApplicationExtension 16.1, *)
struct ArenaOneDynamicIslandTeamView: View {
    let title: String
    let subtitle: String
    let alignment: HorizontalAlignment

    var body: some View {
        VStack(alignment: alignment, spacing: 3) {
            Text(title)
                .font(.caption)
                .fontWeight(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
    }
}

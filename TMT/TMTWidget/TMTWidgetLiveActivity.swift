//
//  TMTWidgetLiveActivity.swift
//  TMTWidget
//
//  Created by 김유빈 on 10/17/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct BusJourneyAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var remainingStopsCount: Int
    }
    
    // Fixed non-changing properties about your activity go here!
    var stopNameKorean: String
    var stopNameRomanized: String
}

struct BusJourneyLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BusJourneyAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(alignment: .leading) {
                Text("\(context.attributes.stopNameRomanized)")
                Text("\(context.attributes.stopNameKorean)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading) {
                        Text("\(context.attributes.stopNameRomanized)")
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                        Text("\(context.attributes.stopNameKorean)")
                        
                    }
                    .padding(.vertical, 8)
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.remainingStopsCount)")
            } minimal: {
                Text("\(context.state.remainingStopsCount)")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension BusJourneyAttributes {
    fileprivate static var preview: BusJourneyAttributes {
        BusJourneyAttributes(stopNameKorean: "효곡동행정복지센터", stopNameRomanized: "Hyo-gok-dong Haeng-jeong Bok-ji Center")
    }
}

extension BusJourneyAttributes.ContentState {
    fileprivate static var smiley: BusJourneyAttributes.ContentState {
        BusJourneyAttributes.ContentState(remainingStopsCount: 5)
    }
    
    fileprivate static var starEyes: BusJourneyAttributes.ContentState {
        BusJourneyAttributes.ContentState(remainingStopsCount: 5)
    }
}

#Preview("Notification", as: .content, using: BusJourneyAttributes.preview) {
    BusJourneyLiveActivity()
} contentStates: {
    BusJourneyAttributes.ContentState.smiley
    BusJourneyAttributes.ContentState.starEyes
}

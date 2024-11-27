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

        var thisStopNameKorean: String
        var thisStopNameRomanized: String
    }
    
    // Fixed non-changing properties about your activity go here!
}

struct BusJourneyLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BusJourneyAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack(spacing: 8) {
                DestinationView(context: context)
                
                RemainingStopsCircleView(remainingStopsCount: context.state.remainingStopsCount)
            }
            .activityBackgroundTint(.white.opacity(0.7)) // TODO: 배경색 수정
            .activitySystemActionForegroundColor(.basicWhite)
            .padding(.horizontal, 15)
            .padding(.vertical, 17.5)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 2) {
                        Image("PinYellow")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.brandPrimary)

                        Text("Destination")
                            .foregroundStyle(.brandPrimary)
                            .font(.system(size: 14))
                    }
                    .padding(.top, 18)
                    .padding(.horizontal, 8)
                }
                
                
                DynamicIslandExpandedRegion(.trailing) {
                    RemainingStopsTextView(remainingStopsCount: context.state.remainingStopsCount)
                        .padding(.top, 18)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    DestinationDetailView(context: context)
                }
            } compactLeading: {
                
            } compactTrailing: {
                Text("\(context.state.remainingStopsCount)")
            } minimal: {
                Text("\(context.state.remainingStopsCount)")
            }
            .keylineTint(.brandPrimary)
        }
    }
}

struct DestinationView: View {
    let context: ActivityViewContext<BusJourneyAttributes>
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 2) {
                Image("PinGrey")
                    .resizable()
                    .frame(width: 12, height: 12)
                
                Text("Destination")
                    .font(.system(size: 14))
                    .foregroundStyle(.basicBlackOpacity40)
            }

            HStack(alignment: .top, spacing: 17) {
                Text("KOR")
                    .foregroundStyle(.basicBlackOpacity40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(context.attributes.stopNameRomanized)
                        .font(.system(size: 14, weight: .semibold))
                        .lineLimit(3)
                    
                    Text(context.attributes.stopNameKorean)
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundStyle(.basicBlack)
                
                Spacer()
            }
        }
    }
}

struct RemainingStopsCircleView: View {
    let remainingStopsCount: Int
    
    var body: some View {
        Circle()
            .frame(width: 75, height: 75)
            .foregroundStyle(circleColor)
            .blur(radius: 12)
            .overlay {
                TextOverlay(remainingStopsCount: remainingStopsCount)
            }
    }
    
    private var circleColor: Color {
        switch remainingStopsCount {
        case 0:
            return .readyOpacity
        case 1:
            return .left1Opacity
        case 2:
            return .left2Opacity
        case 3:
            return .left3Opacity
        default:
            return .brandPrimaryOpacity70
        }
    }
    
    @ViewBuilder
    private func TextOverlay(remainingStopsCount: Int) -> some View {
        if remainingStopsCount == 0 {
            Text("READY")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
        } else {
            VStack(spacing: 0) {
                Text("\(remainingStopsCount)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("left")
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
            }
        }
    }
}

struct RemainingStopsTextView: View {
    let remainingStopsCount: Int
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            Text("\(remainingStopsCount)")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(textColor)
            
            if remainingStopsCount > 0 {
                Text("left")
                    .font(.system(size: 12))
                    .foregroundStyle(textColor)
            }
        }
    }
    
    private var textColor: Color {
        switch remainingStopsCount {
        case 0:
            return .ready
        case 1:
            return .left1
        case 2:
            return .left2
        case 3:
            return .left3
        default:
            return .brandPrimary
        }
    }
}

struct DestinationDetailView: View {
    let context: ActivityViewContext<BusJourneyAttributes>
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("KOR")
                .foregroundStyle(.yellow300)
                .font(.system(size: 16))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(context.attributes.stopNameRomanized)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(context.attributes.stopNameKorean)
            }
            .foregroundStyle(.basicWhite)
            .font(.system(size: 18, weight: .medium))
            
            Spacer()
        }
        .padding(.horizontal, 8)
    }
}


// MARK: - Preview
extension BusJourneyAttributes {
    fileprivate static var preview: BusJourneyAttributes {
        BusJourneyAttributes()
    }
}

extension BusJourneyAttributes.ContentState {
    fileprivate static var HyoGokDong55: BusJourneyAttributes.ContentState {
        BusJourneyAttributes.ContentState(remainingStopsCount: 55, thisStopNameKorean: "효곡동행정복지센터", thisStopNameRomanized: "Hyo-gok-dong Haeng-jeong Bok-ji Center")
    }

    fileprivate static var HyoGokDong3: BusJourneyAttributes.ContentState {
        BusJourneyAttributes.ContentState(remainingStopsCount: 3, thisStopNameKorean: "효곡동행정복지센터", thisStopNameRomanized: "Hyo-gok-dong Haeng-jeong Bok-ji Center")
    }

    fileprivate static var HyoGokDong2: BusJourneyAttributes.ContentState {
        BusJourneyAttributes.ContentState(remainingStopsCount: 2, thisStopNameKorean: "효곡동행정복지센터", thisStopNameRomanized: "Hyo-gok-dong Haeng-jeong Bok-ji Center")
    }

    fileprivate static var HyoGokDong1: BusJourneyAttributes.ContentState {
        BusJourneyAttributes.ContentState(remainingStopsCount: 1, thisStopNameKorean: "효곡동행정복지센터", thisStopNameRomanized: "Hyo-gok-dong Haeng-jeong Bok-ji Center")
    }

    fileprivate static var HyoGokDong0: BusJourneyAttributes.ContentState {
        BusJourneyAttributes.ContentState(remainingStopsCount: 0, thisStopNameKorean: "효곡동행정복지센터", thisStopNameRomanized: "Hyo-gok-dong Haeng-jeong Bok-ji Center")
    }
}

#Preview("Lock Screen", as: .content, using: BusJourneyAttributes.preview) {
    BusJourneyLiveActivity()
} contentStates: {
    BusJourneyAttributes.ContentState.HyoGokDong55
    BusJourneyAttributes.ContentState.HyoGokDong3
    BusJourneyAttributes.ContentState.HyoGokDong2
    BusJourneyAttributes.ContentState.HyoGokDong1
    BusJourneyAttributes.ContentState.HyoGokDong0
}

#Preview("Expanded Dynamic Island", as: .dynamicIsland(.expanded), using: BusJourneyAttributes.preview) {
    BusJourneyLiveActivity()
} contentStates: {
    BusJourneyAttributes.ContentState.HyoGokDong55
    BusJourneyAttributes.ContentState.HyoGokDong3
    BusJourneyAttributes.ContentState.HyoGokDong2
    BusJourneyAttributes.ContentState.HyoGokDong1
    BusJourneyAttributes.ContentState.HyoGokDong0
}

#Preview("Compact Dynamic Island", as: .dynamicIsland(.compact), using: BusJourneyAttributes.preview) {
    BusJourneyLiveActivity()
} contentStates: {
    BusJourneyAttributes.ContentState.HyoGokDong55
    BusJourneyAttributes.ContentState.HyoGokDong3
    BusJourneyAttributes.ContentState.HyoGokDong2
    BusJourneyAttributes.ContentState.HyoGokDong1
    BusJourneyAttributes.ContentState.HyoGokDong0
}

#Preview("Minimal Dynamic Island", as: .dynamicIsland(.minimal), using: BusJourneyAttributes.preview) {
    BusJourneyLiveActivity()
} contentStates: {
    BusJourneyAttributes.ContentState.HyoGokDong55
    BusJourneyAttributes.ContentState.HyoGokDong3
    BusJourneyAttributes.ContentState.HyoGokDong2
    BusJourneyAttributes.ContentState.HyoGokDong1
    BusJourneyAttributes.ContentState.HyoGokDong0
}

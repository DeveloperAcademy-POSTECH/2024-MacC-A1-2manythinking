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
      HStack(alignment: .top, spacing: 0) {
        DestinationView(context: context)
        Spacer()
        RemainingStopsCircleView(remainingStopsCount: context.state.remainingStopsCount)
      }
      .activityBackgroundTint(.grey50) // TODO: 배경색 수정
      .activitySystemActionForegroundColor(.basicBlack)
      .padding(.horizontal, 16)
      .padding(.vertical, 16)
      
    } dynamicIsland: { context in
      DynamicIsland {
        // Expanded UI goes here.  Compose the expanded UI through
        // various regions, like leading/trailing/center/bottom
        
        DynamicIslandExpandedRegion(.leading) {
          HStack(alignment: .center, spacing: 4) {
            Image(systemName: "location.fill")
                .resizable()
                .foregroundColor(.grey50)
                .frame(width: 14, height: 14)
            
            Text("This Stop")
              .font(.system(size: 14, weight: .medium))
              .foregroundStyle(.grey50)
          }
          .padding(.horizontal, 4)
          .padding(.top, 4)
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
      HStack(spacing: 4) {
        Image(systemName: "location.fill")
            .resizable()
            .foregroundColor(.black)
            .frame(width: 12, height: 12)
        
        Text("This Stop")
          .font(.system(size: 14, weight: .medium))
          .foregroundStyle(.black)
      }

      HStack(alignment: .top) {
        VStack(alignment: .leading) {
          Text(context.attributes.stopNameKorean)
            .font(.system(size: 20, weight: .bold))
//            .frame(width: 243, height: 26)
          Text(context.attributes.stopNameRomanized)
            .font(.system(size: 14, weight: .medium))
            .lineLimit(2)
//            .frame(width: 243, height: 38)
        }
        .foregroundStyle(.black)
      }
    }
  }
}

struct RemainingStopsCircleView: View {
  let remainingStopsCount: Int
  
  var body: some View {
    Image("Circle")
      // 이미지 색상 바꾸는 코드 => Circle에 적용하면 다른 Circle 이미지 파일 삭제해용
      .renderingMode(.template)
      .foregroundStyle(.busOliveGreen) // 남은 정거장 수에 따른 색상값 넣으면 됩니다!
      //
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
    if remainingStopsCount == 0 & 1  {
      VStack(spacing: 0) {
        Text("\(remainingStopsCount)")
          .font(.system(size: 24, weight: .bold))
          .foregroundStyle(.black)
        
        Text("Stop Left")
          .font(.system(size: 14))
          .foregroundStyle(.black)
      }
    } else {
      VStack(spacing: 0) {
        Text("\(remainingStopsCount)")
          .font(.system(size: 24, weight: .bold))
          .foregroundStyle(.black)
        
        Text("Stops Left")
          .font(.system(size: 14))
          .foregroundStyle(.black)
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
  
  @State var isAnimating: Bool = false
  
  let timing: Double = 5.0
  let context: ActivityViewContext<BusJourneyAttributes>
  
  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      VStack(alignment: .leading, spacing: 0) {
        Text(context.attributes.stopNameKorean)
          .font(.system(size: 20, weight: .heavy))
        HStack(spacing: 0){
          Text("[")
          Text(context.attributes.stopNameRomanized)
            .font(.system(size: 14, weight: .semibold))
            .lineLimit(2)
            .multilineTextAlignment(.leading)
          Text("]")
        }
      }
      .foregroundStyle(.basicWhite)
      Spacer()
    }
    .padding(.horizontal, 0)
    HStack(alignment: .bottom, spacing: 6) {
      Spacer()
      ZStack{
        Rectangle()
          .frame(width: 120, height: 44)
          .cornerRadius(45)
          .foregroundColor(.grey900)
        HStack(alignment: .firstTextBaseline, spacing: 2){
          Text("20")
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(.brandPrimary)
          Text("Stops Left")
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.brandPrimary)
            
        }
      }
      Circle()
        .frame(width: 44, height: 44)
        .foregroundStyle(.grey200)
      Circle()
        .frame(width: 44, height: 44)
        .foregroundStyle(.brandPrimary)
    }
    .padding(.horizontal, 2)
    
  }
}

extension BusJourneyAttributes {
  fileprivate static var preview: BusJourneyAttributes {
    BusJourneyAttributes(stopNameKorean: "환호공원", stopNameRomanized: "Center")
  }
}

extension BusJourneyAttributes.ContentState {
  fileprivate static var HyoGokDong3: BusJourneyAttributes.ContentState {
    BusJourneyAttributes.ContentState(remainingStopsCount: 3)
  }
  
  fileprivate static var HyoGokDong0: BusJourneyAttributes.ContentState {
    BusJourneyAttributes.ContentState(remainingStopsCount: 0)
  }
}

#Preview("Notification", as: .content, using: BusJourneyAttributes.preview) {
  BusJourneyLiveActivity()
} contentStates: {
  BusJourneyAttributes.ContentState.HyoGokDong3
  BusJourneyAttributes.ContentState.HyoGokDong0
}

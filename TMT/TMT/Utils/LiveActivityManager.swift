//
//  LiveActivityManager.swift
//  TMT
//
//  Created by 김유빈 on 10/17/24.
//

import ActivityKit

final class LiveActivityManager {
    static let shared = LiveActivityManager()

    private var activity: Activity<BusJourneyAttributes>?
    
    func startLiveActivity(startBusStop: BusStop, endBusStop: BusStop, remainingStops: Int) {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            // 실행 중인 라이브 액티비티가 있으면 종료됩니다.
            if let _ = activity {
                return
            }
            
            guard let startNameKorean = endBusStop.stopNameKorean else { return }
            guard let startNameRomanized = endBusStop.stopNameRomanized else { return }
            
            let data = BusJourneyAttributes()
            
            let initialState = BusJourneyAttributes.ContentState(remainingStopsCount: remainingStops, thisStopNameKorean: startNameKorean, thisStopNameRomanized: startNameRomanized)
            
            let content = ActivityContent(state: initialState, staleDate: nil)
            
            do {
                activity = try Activity.request(attributes: data, content: content)
            } catch (let error) {
                print("Error requesting Lockscreen Live Activity(Timer) \(error.localizedDescription).")
            }
        }
        
    }
    
    func endLiveActivity() {
        Task {
            for activity in Activity<BusJourneyAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }

            activity = nil
        }
    }
    
    func updateLiveActivity(remainingStops: Int, thisStop: BusStop) async {
        guard let thisStopNameKorean = thisStop.stopNameKorean else { return }
        guard let thisStopNameRomanized = thisStop.stopNameRomanized else { return }
        
        let contentState = BusJourneyAttributes.ContentState(remainingStopsCount: remainingStops, thisStopNameKorean: thisStopNameKorean, thisStopNameRomanized: thisStopNameRomanized)
        
        // TODO: 애플워치에 뜨는 알림. title, body 내용 수정해야 함. 애플 워치에 알림 안 띄우고 알림 보내는 방법은 없나 ??...
        let alertConfig = AlertConfiguration(
            title: "This Stop is \(thisStopNameKorean)[\(thisStopNameRomanized)].",
            body: "\(remainingStops) stop(s) left.",
            sound: .default
        )
        
        await activity?.update(ActivityContent<BusJourneyAttributes.ContentState>(state: contentState, staleDate: nil), alertConfiguration: alertConfig)
    }
}

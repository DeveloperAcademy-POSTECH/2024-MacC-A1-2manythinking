//
//  LiveActivityManager.swift
//  TMT
//
//  Created by 김유빈 on 10/17/24.
//

import Combine
import ActivityKit

final class LiveActivityManager: ObservableObject {
    private var cancellable: Set<AnyCancellable> = Set()
    private var activity: Activity<BusJourneyAttributes>?

    func startLiveActivity(destinationInfo: BusStopInfo, remainingStops: Int) {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            // 실행 중인 라이브 액티비티가 있으면 종료됩니다.
            if let _ = activity {
                return
            }
            
            guard let stopNameKorean = destinationInfo.stopNameKorean else { return }
            guard let stropNameRomanized = destinationInfo.stopNameRomanized else { return }
            
            let data = BusJourneyAttributes(stopNameKorean: stopNameKorean, stopNameRomanized: stropNameRomanized)
            
            let initialState = BusJourneyAttributes.ContentState(remainingStopsCount: remainingStops)
            
            let content = ActivityContent(state: initialState, staleDate: nil)
            
            do {
                activity = try Activity.request(attributes: data, content: content)
            } catch (let error) {
                print("Error requesting Lockscreen Live Activity(Timer) \(error.localizedDescription).")
            }
        }
        
    }
    
    func endLiveActivity() {
        let finalContent = BusJourneyAttributes.ContentState(remainingStopsCount: 0)
        
        let dismissalpolicy: ActivityUIDismissalPolicy = .immediate
        
        Task {
            await activity?.end(ActivityContent(state: finalContent, staleDate: nil), dismissalPolicy: dismissalpolicy)
        }
    }
    
    func updateLiveActivity(remainingStops: Int) async {
        let contentState = BusJourneyAttributes.ContentState(remainingStopsCount: remainingStops)
        
        // TODO: 애플워치에 뜨는 알림. title, body 내용 수정해야 함. 애플 워치에 알림 안 띄우고 알림 보내는 방법은 없나 ??...
        let alertConfig = AlertConfiguration(
            title: "title",
            body: "body",
            sound: .default
        )
        
        await activity?.update(ActivityContent<BusJourneyAttributes.ContentState>(state: contentState, staleDate: nil), alertConfiguration: alertConfig)
    }
}

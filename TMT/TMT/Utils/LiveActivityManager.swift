//
//  LiveActivityManager.swift
//  TMT
//
//  Created by 김유빈 on 10/17/24.
//

import Combine
import ActivityKit

@available(iOS 16.2, *)
final class LiveActivityManager: ObservableObject {
    @Published var num: Int = 0
    private var cancellable: Set<AnyCancellable> = Set()
    private var activity: Activity<BusJourneyAttributes>?
    
    func startLiveActivity(destinationInfo: BusStopInfo) {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            // 실행 중인 라이브 액티비티가 있으면 종료됩니다.
            if let _ = activity {
                return
            }
            
            guard let stopNameKorean = destinationInfo.stopNameKorean else { return }
            guard let stropNameRomanized = destinationInfo.stopNameRomanized else { return }
            
            let data = BusJourneyAttributes(stopNameKorean: stopNameKorean, stopNameRomanized: stropNameRomanized)
            
            let initialState = BusJourneyAttributes.ContentState(remainingStopsCount: 0)
            
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
    
    // TODO: 값에 변화생기면 라이브 액티비티 update 하는 코드입니다.
    // 나중에 참고하려고 넣어놨어요. 값 업데이트되면 자동으로 다이나믹 아일랜드 확장형으로 보여줍니다.
//    func timer() {
//        Timer.publish(every: 10, on: .main, in: .default)
//            .autoconnect()
//            .sink { [self] _ in
//                num += 1
//                Task {
//
//                    print(num)
//                    let activity = self.activity
//                    let newState = BusJourneyAttributes.ContentState(remainingStopsCount: num)
//                    // 애플워치에서 동작
//                    let alertConfiguration = AlertConfiguration(
//                        title: "timer update",
//                        body: "현재숫자: \(num)",
//                        sound: .default
//                    )
//                    await activity?.update(using: newState, alertConfiguration: alertConfiguration)
//                }
//            }
//            .store(in: &cancellable)
//    }

}

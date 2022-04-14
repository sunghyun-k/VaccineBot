//
//  VaccineBot.swift
//  
//
//  Created by 김성현 on 2021/07/17.
//

import Foundation
import Sword

struct VaccineBot {
    
    private let bot: Sword
    private let checker = VaccineChecker()
    private let timer: DispatchSourceTimer
    private let channelID: Snowflake = Snowflake(0) // 메시지를 보낼 채널 ID
    
    init(token: String) {
        
        bot = Sword(token: token)
        
        let queue = DispatchQueue(label: "vaccinebot.timer")  // 원한다면 `DispatchQueue.main`도 사용가능
        timer = DispatchSource.makeTimerSource(queue: queue)
        
        setupTimer()
        setupBot()
    }
    
    private func setupBot() {
        bot.editStatus(to: "online", playing: "")
        
        bot.on(.messageCreate) { data in
            let message = data as! Message
            guard !message.content.isEmpty else { return }
            // 메시지에 답장을 할 경우 코드 작성
        }
    }
    
    private func setupTimer() {
        timer.schedule(deadline: .now(), repeating: .milliseconds(610*1))
        timer.setEventHandler(handler: check)
    }
    
    private func check() {
        checker.fetchHospitals { hospitals, error in
            guard error == nil else {
                print("\(Date().timestamp) 오류: \(error!.localizedDescription)")
                return
            }
            hospitals.forEach { hospital in
                self.sendIfAvail(hospital: hospital)
            }
        }
    }
    
    private func sendIfAvail(hospital: Hospital) {
        guard let vaccine = hospital.vaccineQuantity else { return }
        guard vaccine.totalQuantity > 0 else { return }
        #if os(macOS)
        let sourceCode = "tell application \"Keyboard Maestro Engine\" to do script \"940EAA36-C93F-44C5-9AFD-827560A22228\" with parameter \"\(hospital.reservationURL!.absoluteString)\""
        NSAppleScript(source: sourceCode)!.executeAndReturnError(nil)
        #endif
        let message = self.hospitalEmbed(hospital)
        bot.send(message, to: channelID)
    }
    
    func run() {
        print("봇 실행됨")
        timer.resume()
        bot.connect()
    }
    
    private func hospitalEmbed(_ hospital: Hospital) -> Embed {
        
        let vaccine = hospital.vaccineQuantity!
        
        var embed = Embed()
        let color: Int
        switch vaccine.totalQuantityStatus {
        case .plenty:
            color = 0x00D166 // 초록
        case .some:
            color = 0xF8C300 // 노랑
        case .few:
            color = 0xF93A2F // 빨강
        default:
            color = 0x91A6A6 // 회색
        }
        embed.color = color
        embed.title = hospital.name
        embed.description = "\(hospital.roadAddress) (\(hospital.address))"
        embed.url = hospital.url.absoluteString
        embed.addField("잔여수량", value: "\(vaccine.totalQuantityStatus.description) (\(vaccine.totalQuantity.description))", isInline: false)
        embed.addField("예약링크", value: hospital.reservationURL!.absoluteString, isInline: false)
        return embed
    }
}

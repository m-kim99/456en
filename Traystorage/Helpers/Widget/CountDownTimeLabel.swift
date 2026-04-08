//
//  DownTimeLabel.swift
//  Traystorage
//
//

import Foundation
import UIKit

protocol CountDownTimeIsUp {
    func onTimeIsUp(sender: CountDownTimeLabel)
}

@IBDesignable
class CountDownTimeLabel: UIFontLabel {
    @IBInspectable var startDownTime: Int = 180 {
        didSet {
            countDownTime = startDownTime
        }
    }
    
    open var timeIsUpDelegate: CountDownTimeIsUp?
    
    var countDownTimer:  Timer?
    private var countDownTime = 0
    
    func startCountDownTimer() {
        stopTimer()
        self.countDownTime = startDownTime
        updateCountDownLabelText()
        self.isHidden = false;
        
        let countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] timer in
            
            guard let weakSelf = self else {
                return
            }
            
            weakSelf.countDownTime -= 1
            
            if weakSelf.countDownTime <= 0 {
                timer.invalidate()
                
                if let delegate = weakSelf.timeIsUpDelegate {
                    delegate.onTimeIsUp(sender: weakSelf)
                }
            }
            
            weakSelf.updateCountDownLabelText()
        })
        
        self.countDownTimer = countDownTimer
    }
    
    func onCountDown(_ sender: Any) {
        
    }
    
    func stopTimer() {
        if let oldTimer = self.countDownTimer {
            oldTimer.invalidate()
        }
    }
    
    private func updateCountDownLabelText() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        self.text = formatter.string(from: TimeInterval(self.countDownTime))
    }
}

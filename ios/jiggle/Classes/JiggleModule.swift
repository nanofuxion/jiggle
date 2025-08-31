import Foundation
import UIKit
import CoreHaptics
import AudioToolbox

@objc(JiggleModule)
public class JiggleModule: NSObject {
  private var engine: CHHapticEngine?

  public override init() {
    super.init()
    prepareEngine()
  }

  private func prepareEngine() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
    do {
      engine = try CHHapticEngine()
      try engine?.start()
    } catch {
      engine = nil
    }
  }

  /// Vibrate for a duration in milliseconds (matches Android behavior)
  @objc
  public func vibrate(_ duration: NSNumber) {
    let ms = duration.doubleValue
    let seconds = max(0.01, ms / 1000.0)

    if let engine = engine, CHHapticEngine.capabilitiesForHardware().supportsHaptics {
      let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
      let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
      let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: seconds)
      do {
        let pattern = try CHHapticPattern(events: [event], parameters: [])
        let player = try engine.makePlayer(with: pattern)
        try player.start(atTime: 0)
      } catch {
        // fallback to system vibrate
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
      }
    } else {
      // fallback to system vibrate
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
  }
}

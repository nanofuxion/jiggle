import Foundation
import UIKit
import CoreHaptics
import AudioToolbox

@objcMembers // Add this attribute
public final class JiggleModule: NSObject, LynxModule {
    // The rest of your code remains the same...

    @objc public static var name: String {
        return "JiggleModule"
    }

    @objc public static var methodLookup: [String: String] {
        return [
            "vibrate": NSStringFromSelector(#selector(vibrate(_:)))
        ]
    }
    
  private var engine: CHHapticEngine?

    // Add this required initializer
    @objc public init(param: Any) {
        super.init()
        prepareEngine()
    }

    @objc public override init() {
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
  @objc public func vibrate(_ duration: NSNumber) {
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

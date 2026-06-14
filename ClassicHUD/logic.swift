/* * * * * * * * * * * * * * * * *
 *                               *
 *    https://github.com/d3gk    *
 *    Distributed under GPLv3    *
 *                               *
 * * * * * * * * * * * * * * * * */

import SwiftUI;
import AppKit;
import Foundation;
import CoreAudio;
import IOKit;
import IOKit.graphics;
import CoreGraphics;
import Darwin;

func GetBrightness() -> Float? {
    guard
        let handle = dlopen(
            "/System/Library/PrivateFrameworks/DisplayServices.framework/DisplayServices",
            RTLD_LAZY
        )
    else {
        return nil;
    }

    defer { 
        dlclose(handle); 
    }

    typealias CanChangeBrightness =
        @convention(c) (CGDirectDisplayID) -> Bool

    typealias GetBrightnessFunc =
        @convention(c) (CGDirectDisplayID, UnsafeMutablePointer<Float>) -> kern_return_t

    guard
        let canChangePtr = dlsym(handle, "DisplayServicesCanChangeBrightness"),
        let getBrightnessPtr = dlsym(handle, "DisplayServicesGetBrightness")
    else {
        return nil;
    }

    let canChangeBrightness = unsafeBitCast(
        canChangePtr,
        to: CanChangeBrightness.self
    );

    let getBrightness = unsafeBitCast(
        getBrightnessPtr,
        to: GetBrightnessFunc.self
    );

    var count: UInt32 = 0;
    guard CGGetActiveDisplayList(0, nil, &count) == .success else {
        return nil;
    }

    var displays = [CGDirectDisplayID](repeating: 0, count: Int(count));
    guard CGGetActiveDisplayList(count, &displays, &count) == .success else {
        return nil;
    }

    guard let display = displays.first(where: { CGDisplayIsBuiltin($0) != 0 }) else {
        return nil;
    }

    guard canChangeBrightness(display) else {
        return nil;
    }

    var brightness: Float = 0;
    guard getBrightness(display, &brightness) == KERN_SUCCESS else {
        return nil;
    }

    return brightness;
}

func GetVolume() -> Float? {
    var defaultOutputDevice = AudioDeviceID(0);
    var size = UInt32(MemoryLayout<AudioDeviceID>.size);

    var address = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDefaultOutputDevice,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    );

    guard AudioObjectGetPropertyData(
        AudioObjectID(kAudioObjectSystemObject),
        &address,
        0,
        nil,
        &size,
        &defaultOutputDevice
    ) == noErr else {
        return nil;
    }

    var volume: Float32 = 0;

    address = AudioObjectPropertyAddress(
        mSelector: kAudioDevicePropertyVolumeScalar,
        mScope: kAudioDevicePropertyScopeOutput,
        mElement: kAudioObjectPropertyElementMain
    );

    size = UInt32(MemoryLayout<Float32>.size);

    guard AudioObjectGetPropertyData(
        defaultOutputDevice,
        &address,
        0,
        nil,
        &size,
        &volume
    ) == noErr else {
        return nil;
    }

    return Float(volume);
}

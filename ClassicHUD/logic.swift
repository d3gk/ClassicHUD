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

func GetBrightness() -> Float? {
    var iterator: io_iterator_t = 0

    guard IOServiceGetMatchingServices(
        kIOMainPortDefault,
        IOServiceMatching("IODisplayConnect"),
        &iterator
    ) == KERN_SUCCESS else {
        return nil;
    }

    defer { 
        IOObjectRelease(iterator); 
    }

    var service: io_object_t;
    repeat {
        service = IOIteratorNext(iterator);

        if service != 0 {
            var brightness: Float = 0;

            if IODisplayGetFloatParameter(
                service,
                0,
                kIODisplayBrightnessKey as CFString,
                &brightness
            ) == KERN_SUCCESS {
                IOObjectRelease(service);
                return brightness;
            }

            IOObjectRelease(service);
        }
    } while service != 0;

    return nil;
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

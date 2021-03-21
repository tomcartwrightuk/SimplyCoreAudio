//
//  SCATestCase.swift
//  
//
//  Created by Ruben Nine on 21/3/21.
//

import XCTest
@testable import SimplyCoreAudio

class SCATestCase: XCTestCase {
    var simplyCA: SimplyCoreAudio!
    var defaultInputDevice: AudioDevice?
    var defaultOutputDevice: AudioDevice?
    var defaultSystemOutputDevice: AudioDevice?

    override func setUp() {
        super.setUp()

        simplyCA = SimplyCoreAudio()
        defaultInputDevice = simplyCA.defaultInputDevice
        defaultOutputDevice = simplyCA.defaultOutputDevice
        defaultSystemOutputDevice = simplyCA.defaultSystemOutputDevice

        try? resetNullDeviceState()
    }

    override func tearDown() {
        super.tearDown()

        simplyCA = nil
        resetDefaultDevices()
        try? resetNullDeviceState()
    }

    func getNullDevice(file: StaticString = #file, line: UInt = #line) throws -> AudioDevice {
        try XCTUnwrap(AudioDevice.lookup(by: "NullAudioDevice_UID"), "NullAudio driver is missing.", file: file, line: line)
    }

    func resetNullDeviceState() throws {
        let device = try getNullDevice()

        device.unsetHogMode()

        if device.nominalSampleRate != 44100 {
            device.setNominalSampleRate(44100)
            wait(for: 1)
        }

        device.setPreferredChannelsForStereo(channels: StereoPair(left: 1, right: 2), scope: .output)
        device.setMute(false, channel: 0, scope: .output)
        device.setMute(false, channel: 0, scope: .input)
        device.setVolume(0.5, channel: 0, scope: .output)
        device.setVolume(0.5, channel: 0, scope: .input)
        device.setVirtualMasterVolume(0.5, scope: .output)
        device.setVirtualMasterVolume(0.5, scope: .input)
    }
}

// MARK: - Private Functions

private extension SCATestCase {
    func resetDefaultDevices() {
        defaultInputDevice?.setAsDefaultInputDevice()
        defaultOutputDevice?.setAsDefaultOutputDevice()
        defaultSystemOutputDevice?.setAsDefaultSystemDevice()
    }
}
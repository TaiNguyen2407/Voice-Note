//
// Created by Anwar Ulhaq on 1.4.2023, developed by Giao Ngo
// Learning resource on AVAudioRecorder and AVAudioPlayer:
// https://mdcode2021.medium.com/audio-recording-in-swiftui-mvvm-with-avfoundation-an-ios-app-6e6c8ddb00cc
//

import Foundation
import AVFoundation

class VoiceNoteViewModel: ObservableObject{
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    
    @Published var isRecording: Bool = false
    @Published var recordingList = [Recording]()
    @Published var fileUrlList = [URL]()
    
    init () {
        self.fetchAllRecordings()
    }
    /**
        This function starts the recording, writes the audio records to FileManager
     */
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Recording Setup Error: \(error.localizedDescription)")
        }
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YY 'at' HH:mm:ss"
        let formattedDate = dateFormatter.string(from: currentDate)
        let audioFileName = path.appendingPathComponent("VoiceNote:\(formattedDate).m4a")
        fileUrlList.append(audioFileName)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            
        } catch {
            print("Error Setting Up Recorder \(error.localizedDescription)")
        }
    }
    
    /**
        This function stops the recording
     */
    func stopRecording() {
        audioRecorder?.stop()
    }
    
    /**
        This function fetches all of the recordings to the FileManager and appends its data to the recording lists
     */
    private func fetchAllRecordings() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let recordingsContent = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            for url in recordingsContent {
                recordingList.append(Recording(fileUrl: url, createdAt: getFileDate(for: url), isPlaying: false))
            }
        } catch {
            print("Error fetching all recordings \(error.localizedDescription)")
        }
    }
    
    /**
        This function fetches the creation date of a file
     */
    private func getFileDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
           let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
}

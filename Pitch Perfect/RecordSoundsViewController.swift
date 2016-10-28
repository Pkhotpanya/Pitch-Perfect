//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Peter Khotpanya on 10/24/16.
//  Copyright © 2016 Peter Khotpanya. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons(recording: false)
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        configureButtons(recording: true)
        
        startRecordingAudio()
    }

    @IBAction func stopRecording(_ sender: AnyObject) {
        configureButtons(recording: false)
        
        stopRecordingAudio()
    }
    
    func configureButtons(recording: Bool){
        if (recording){
            recordingLabel.text = "Recording in progress"
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
        } else {
            recordingLabel.text = "Tap to Record"
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
        }
    }
    
    func startRecordingAudio(){

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecordingAudio(){
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag){
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            //Failed to record
            let alert=UIAlertController(title: "Failed to record audio", message: "", preferredStyle: UIAlertControllerStyle.alert);
            //show it
            show(alert, sender: self);
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}


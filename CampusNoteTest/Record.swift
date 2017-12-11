
import UIKit
import Speech

class Record: UIViewController, SFSpeechRecognizerDelegate {
    
    // MARK : - Variable
    @IBOutlet weak var STT: UIButton!
    @IBOutlet weak var RecordTextView: UITextView! // 작성된 메모가 보여지는 테이블
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var MemoData = [String]()
    //Variable_End
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let MemoNumber = UserDefaults.standard.object(forKey: "MemoNumber") as! Int
        
        
        if MemoNumber == -1 { // 추가버튼
            if UserDefaults.standard.object(forKey: "MemoData") as? [String] != nil { // nil값이 들어있는지 확인
                MemoData = UserDefaults.standard.object(forKey: "MemoData") as! [String] // 저장된 MemoData를 불러옴
                RecordTextView.text = "" // 새로 작성하는 메모에서 보여지는 것
            }
        } else { // 리스트 선택
            MemoData = UserDefaults.standard.object(forKey: "MemoData") as! [String] // 저장된 MemoData를 불러옴
            RecordTextView.text = MemoData[MemoNumber] // 해당 MemoNumber에 있는 MemoData의 텍스트뷰를 불러옴
        }
        
        
        speechRecognizer?.delegate = self
    }
    
    // MARK: - Action
    @IBAction func Save(_ sender: Any) { // 작성한 메모를 저장하는 버튼
        let MemoNumber = UserDefaults.standard.object(forKey: "MemoNumber") as! Int // MemoNumber를 가져옴
        if MemoNumber == -1 { // 추가버튼으로 넘어옴
            MemoData.insert(RecordTextView.text, at: 0) // 작성한 메모를 0번째에 삽입
            UserDefaults.standard.set(MemoData, forKey: "MemoData") // MemoData란 이름으로 MemoData를 저장
        } else { // 리스트로부터 넘어옴
            MemoData.remove(at: MemoNumber) // 위치에 있는 메모를 삭제
            MemoData.insert(RecordTextView.text, at: MemoNumber)
            UserDefaults.standard.set(MemoData, forKey: "MemoData")
        } // 삭제된 위치에 다시 생성 == 메모수정의 기능
    }
    
    @IBAction func Delete(_ sender: Any) { // 작성한 메모를 삭제하는 버튼
        let MemoNumber = UserDefaults.standard.object(forKey: "MemoNumber") as! Int
        
        if MemoNumber != -1 { // 추가버튼이 아니면
            MemoData.remove(at: MemoNumber) // 위치에 있는 메모를 삭제
            UserDefaults.standard.set(MemoData, forKey: "MemoData")
        }
    }
    
    @IBAction func speechToText(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            STT.isEnabled = false
            STT.setTitle("Start", for: .normal)
        } else {
            startRecording()
            STT.setTitle("Stop", for: .normal)
        }
    }
    //Action_End
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.RecordTextView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.STT.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            STT.isEnabled = true
        } else {
            STT.isEnabled = false
        }
    }
}

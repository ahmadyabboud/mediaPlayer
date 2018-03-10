
import UIKit
import AVFoundation


class ViewController: UIViewController {

  
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var timeFromStart: UILabel!
    var player: AVAudioPlayer?
    var albumSongs = ["Adele - Hello","Adele - Skyfall (Lyric Video)"]
    var index = 0
    var currentTime:Double = 0
    @IBOutlet weak var albumCover: UIImageView!
    @IBAction func previous(_ sender: Any) {
        slider.setValue(0, animated: true)
        index = index - 1
        currentTime = 0
        if index < 0
        {
            index = albumSongs.count - 1
        }
        playSound(name: albumSongs[index],time: currentTime)
    }
    @IBAction func play(_ sender: Any) {
        playSound(name: albumSongs[index],time : currentTime)
    }
    
    @IBAction func next(_ sender: Any) {
        slider.setValue(0, animated: true)
       index = (index + 1) % albumSongs.count
          currentTime = 0
        playSound(name: albumSongs[index],time: currentTime)
    }
    @IBAction func pause(_ sender: Any) {
        currentTime = (player?.currentTime)!
        player?.pause()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            // Session is Active
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
           
        } catch {
            print(error)
        }
        
        
        index = 0
        currentTime = 0
        playSound(name: albumSongs[index],time: currentTime)
        player?.prepareToPlay()
        slider.setValue(0, animated: true)
        // Do any additional setup after loading the view, typically from a nib.
        var timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
      
        timeFromStart.text = "00:00"
        if let tim =  player?.duration
        {
        time.text = "\(tim)"
        }
        getTime()
    }
    func playSound(name:String,time:Double) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("url not found")
            return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
           
            var asset = AVAsset(url: url) as AVAsset
            for metaDataItems in asset.commonMetadata {
                //getting the title of the song
                if metaDataItems.commonKey!.rawValue == "title" {
                    let titleData = metaDataItems.value as! NSString
                    songName.text = "\(titleData)"
                }
                if metaDataItems.commonKey!.rawValue == "artist" {
                    let artistData = metaDataItems.value as! NSString
                   
                    artist.text = "\(artistData)"
                }
              
                if metaDataItems.commonKey!.rawValue == "artwork" {
                    let imageData = metaDataItems.value as! NSData
                    var image2: UIImage = UIImage(data: imageData as Data)!
                   albumCover.image = image2
                }
            }
            slider.maximumValue = Float((player?.duration)!)
            slider.minimumValue = 0
         
            guard let player = player else { return }
            player.currentTime = currentTime
           
            player.play()
        
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    @IBAction func changeAudio(_ sender: Any) {
        player?.currentTime = TimeInterval(slider.value)
       
    }
    @objc func updateSlider()
   {
     slider.value = Float((player?.currentTime)!)
     getTime()
    }

    func getTime()
    {
    
        if let tim =  player?.duration
        {
            var timm = Float((player?.duration)!) - Float((player?.currentTime)!)
            var hours = Int(timm / 3600)
            var minutes = Int((timm.truncatingRemainder(dividingBy: 3600)) / 60)
            var seconds = Int(timm.truncatingRemainder(dividingBy: 60))
            
            var timeS:String!
            if hours == 0
            {
                   timeS = String(format: "%02i:%02i", minutes, seconds)
            }
            else
            {
                  timeS = String(format: "%i:%02i:%02i", hours, minutes, seconds)
            }
            time.text = timeS
            timm = Float((player?.currentTime)!)
            hours = Int(timm / 3600)
            minutes = Int((timm.truncatingRemainder(dividingBy: 3600)) / 60)
            seconds = Int(timm.truncatingRemainder(dividingBy: 60))
            
            if hours == 0
            {
                timeS = String(format: "%02i:%02i", minutes, seconds)
            }
            else
            {
                timeS = String(format: "%i:%02i:%02i", hours, minutes, seconds)
            }
            timeFromStart.text = timeS
        }
     
    }

   
}


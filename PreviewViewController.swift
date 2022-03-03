//
//  PreviewViewController.swift
//  Aurora
//
//  Created by AugursMacbook on 06/09/21.
//

import UIKit
import AVFoundation
import Alamofire

class PreviewViewController: UIViewController {

    
    @IBOutlet weak var bannerImage_Imageview: UIImageView!
    @IBOutlet weak var bgImage_Imageview: UIImageView!
    @IBOutlet weak var desriptionView_Ctrl: UIView!
    @IBOutlet weak var bgView_Ctrl: UIView!
    @IBOutlet weak var swipegesture_bgVIew: UIView!
    @IBOutlet weak var scrollView_Ctrl: UIScrollView!
    @IBOutlet weak var description_txtView: UITextView!
    @IBOutlet weak var scrollViewContent: UIView!
    @IBOutlet weak var uperDescriptionView_Ctrl: UIView!
    @IBOutlet weak var collectionView_Ctrl: UICollectionView!
    @IBOutlet weak var heartIcon_Btn: UIButton!
    @IBOutlet weak var description_Label: UILabel!
    @IBOutlet weak var openDescriptionBtn: UIButton!
    @IBOutlet weak var BgView_top: NSLayoutConstraint!
    @IBOutlet weak var description_btn: UIButton!
    @IBOutlet weak var playBg_View: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var timeDuration_Lbl: UILabel!
    @IBOutlet weak var bannerTop_const: NSLayoutConstraint!
    @IBOutlet weak var premiumBtn: UIButton!
    @IBOutlet weak var fullAccess_Lbl: UILabel!
    
    @IBOutlet weak var sedays_Lbl: UILabel!
    var musicDetailDict : NSDictionary = [:]
    var isOpen : Bool = true
    var favourite:[favourite] = []
    var db:DBHelper = DBHelper()
    var isFavourite : Bool = true
    private var audioPlayer: AVPlayer?
    var isPlay : Bool = true
    var reviewArray : NSMutableArray = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(musicDetailDict)
        
        if musicDetailDict.object(forKey: "largeImageURL") != nil
        {
            bgImage_Imageview?.setImageWith(URL(string: (musicDetailDict.object(forKey: "largeImageURL") as? String)!), placeholderImage: UIImage(named: "user-1"))
        }
        else
        {
           bgImage_Imageview.image = UIImage(named: "songBanner")
        }
        timeDuration_Lbl.text = ""
        if let duration = musicDetailDict.object(forKey: "previewMp3Length")
        {
            timeDuration_Lbl.text = "0." + (duration as! String)
        }
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .up
        self.uperDescriptionView_Ctrl.addGestureRecognizer(swipeDown)
        
        desriptionView_Ctrl.clipsToBounds = true
        desriptionView_Ctrl.layer.cornerRadius = 30
        desriptionView_Ctrl.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        desriptionView_Ctrl.backgroundColor = UIColor.clear
       // desriptionView_Ctrl.isHidden = true
        playBg_View.layer.cornerRadius = 25.0
        playBg_View.clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bgImage_Imageview.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bgImage_Imageview.addSubview(blurEffectView)
        
        bannerImage_Imageview.layer.cornerRadius = 20.0
        bannerImage_Imageview.clipsToBounds = true
        
        if  musicDetailDict.object(forKey: "largeImageURL") != nil
        {
            bannerImage_Imageview?.setImageWith(URL(string: (musicDetailDict.object(forKey: "largeImageURL") as? String)!), placeholderImage: UIImage(named: "user-1"))
        }
        else
        {
            bannerImage_Imageview.image = UIImage(named: "songBanner")
        }
        
        print(musicDetailDict)
        self.favourite = self.db.read()
        
        if musicDetailDict.object(forKey: "musicPremium") is String
        {
            if musicDetailDict.object(forKey: "musicPremium") != nil && musicDetailDict.object(forKey: "musicPremium") as! String == "1"
            {
                heartIcon_Btn.setImage(UIImage(named: "padlock"), for: .normal)
            } else {
                for i in 0..<self.favourite.count
                {
                    if musicDetailDict.object(forKey: "musicID") as? String == self.favourite[i].musicId
                    {
                        heartIcon_Btn.setImage(UIImage(named: "heart-Pink-2"), for: .normal)
                        isFavourite = false
                        break
                    }
                }
            }
        } else {
            if musicDetailDict.object(forKey: "musicPremium") != nil && musicDetailDict.object(forKey: "musicPremium") as! Int == 1
            {
                heartIcon_Btn.setImage(UIImage(named: "padlock"), for: .normal)
            } else {
                for i in 0..<self.favourite.count
                {
                    if musicDetailDict.object(forKey: "musicID") as? String == self.favourite[i].musicId
                    {
                        heartIcon_Btn.setImage(UIImage(named: "heart-Pink-2"), for: .normal)
                        isFavourite = false
                        break
                    }
                }
            }
        }
        
        
        if musicDetailDict.object(forKey: "musicDescription") != nil
        {
            description_txtView.text = (musicDetailDict.object(forKey: "musicDescription") as! String)
            description_Label.text = (musicDetailDict.object(forKey: "musicDescription") as! String)
        }
        
        if (musicDetailDict.object(forKey: "musicDescription") != nil) && (musicDetailDict.object(forKey: "musicDescription2") != nil)
        {
            description_txtView.text = (musicDetailDict.object(forKey: "musicDescription") as! String) + "\n" + "\n" + (musicDetailDict.object(forKey: "musicDescription2") as! String)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView_Ctrl.collectionViewLayout = layout
        getPreviewReview()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let isPurchase = UserDefaults.standard.object(forKey: "isMusicPurchase"), isPurchase as! String == "yes" {
            premiumBtn.isHidden = true
            sedays_Lbl.isHidden = true
            fullAccess_Lbl.isHidden = true
        } else {
            premiumBtn.isHidden = false
            sedays_Lbl.isHidden = false
            fullAccess_Lbl.isHidden = false
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        isOpen = true
        description_txtView.isHidden = true
        openDescriptionBtn.setImage(UIImage(named: "info"), for: .normal)
        scrollView_Ctrl.isScrollEnabled = true
        UIView.transition(with: self.view!, duration: 0.8, options: .transitionCrossDissolve, animations: {() -> Void in
                            self.desriptionView_Ctrl.isHidden = true
                            self.openDescriptionBtn.isHidden = true
                            self.description_Label.isHidden = false
                            self.BgView_top.constant = 20
                         //   self.scrollView_Ctrl.isUserInteractionEnabled = true
                        }, completion: { _ in })
    }
   
    
    func getPreviewReview()
    {
        var baseUrl : String = ""
        baseUrl = Constant.serverURL + "getReviews?musicID=" + (musicDetailDict.object(forKey: "musicID") as! String)
       // baseUrl = "https://www.aurorasleepmusic.com/_functions/getReviews?musicID=eternalom"
        Alamofire.request(baseUrl, method : .get, parameters: nil, headers: nil)
            .responseJSON
            { response in
                print(response)
                if String(describing: response.result) == "SUCCESS"
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if(response.response?.statusCode == 200)
                    {
                        let tempArray = (response.result.value! as! NSDictionary).object(forKey: "reviews") as? NSArray
                        self.reviewArray = tempArray?.mutableCopy() as! NSMutableArray
                        print(self.reviewArray)
                        self.collectionView_Ctrl.reloadData()
                        
                    }
                    else
                    {
                       // supportingfuction.showMessageHudWithMessage("No Review Found." as NSString,delay: 2.0)
                    }
                }
                else
                {
                   //  supportingfuction.showMessageHudWithMessage("No Review Found." as NSString,delay: 2.0)
                }
            }
    }
    
    @IBAction func settingBtn_ACtion(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtn_Action(_ sender: Any) {
        if audioPlayer != nil
        {
            audioPlayer?.replaceCurrentItem(with: nil)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gotoPreniumView_Action(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PurchasePopViewController") as! PurchasePopViewController
       // self.present(vc, animated: false, completion: nil)
       // vc.musicDetailDict = tempDict?.mutableCopy() as! NSMutableDictionary
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func show_description(_ sender: Any)
    {
        if isOpen == true
        {
            isOpen = false
           // bgView_Ctrl.isHidden = true
           // bannerTop_const.constant = 25
            description_txtView.isHidden = false
            openDescriptionBtn.setImage(UIImage(named: "UParrow-1"), for: .normal)
            scrollView_Ctrl.isScrollEnabled = false
                UIView.transition(with: self.view!, duration: 0.8, options: .transitionCrossDissolve, animations: {() -> Void in
                    self.desriptionView_Ctrl.isHidden = false
                    self.openDescriptionBtn.isHidden = false
                    self.description_Label.isHidden = true
                    self.BgView_top.constant = 215
                   // self.scrollView_Ctrl.isUserInteractionEnabled = false
                }, completion: { _ in })
        }
        else
        {
            isOpen = true
            description_txtView.isHidden = true
            openDescriptionBtn.setImage(UIImage(named: "info"), for: .normal)
            scrollView_Ctrl.isScrollEnabled = true
            UIView.transition(with: self.view!, duration: 0.8, options: .transitionCrossDissolve, animations: {() -> Void in
                                self.desriptionView_Ctrl.isHidden = true
                                self.openDescriptionBtn.isHidden = true
                                self.description_Label.isHidden = true
                                self.BgView_top.constant = 20
                             //   self.scrollView_Ctrl.isUserInteractionEnabled = true
                            }, completion: { _ in })
        }
    }
    
    @IBAction func openDescription_Action(_ sender: Any)
    {
        if isOpen == true
        {
            isOpen = false
            description_txtView.isHidden = false
            openDescriptionBtn.setImage(UIImage(named: "UParrow-1"), for: .normal)
            scrollView_Ctrl.isScrollEnabled = false
                UIView.transition(with: self.view!, duration: 0.8, options: .transitionCrossDissolve, animations: {() -> Void in
                    self.desriptionView_Ctrl.isHidden = false
                    self.openDescriptionBtn.isHidden = false
                    self.desriptionView_Ctrl.isHidden = false
                    self.description_Label.isHidden = false
                    self.BgView_top.constant = 255
                   // self.scrollView_Ctrl.isUserInteractionEnabled = false
                }, completion: { _ in })
        }
        else
        {
            isOpen = true
            description_txtView.isHidden = true
            openDescriptionBtn.setImage(UIImage(named: "info"), for: .normal)
            scrollView_Ctrl.isScrollEnabled = true
            UIView.transition(with: self.view!, duration: 0.8, options: .transitionCrossDissolve, animations: {() -> Void in
                                self.desriptionView_Ctrl.isHidden = true
                                self.openDescriptionBtn.isHidden = true
                                self.desriptionView_Ctrl.isHidden = true
                    self.description_Label.isHidden = false
                                self.BgView_top.constant = 20
                             //   self.scrollView_Ctrl.isUserInteractionEnabled = true
                            }, completion: { _ in })
        }

    }
    
    @IBAction func heartIcon_Action(_ sender: Any)
    {
        if musicDetailDict.object(forKey: "musicPremium") is String
        {
            if musicDetailDict.object(forKey: "musicPremium") != nil && musicDetailDict.object(forKey: "musicPremium") as! String == "1"
            {
                
            } else {
                if isFavourite == true
                {
                 isFavourite = false
                 db.insert(songId: (musicDetailDict.object(forKey: "musicID") as? String)!, updateStatus: "1")
                 heartIcon_Btn?.setImage(UIImage(named: "heart-Pink-2"), for: .normal)
                }
                 else
                {
                 isFavourite = true
                 self.db.deleteByID(id: (musicDetailDict.object(forKey: "musicID") as? String)!)
                 heartIcon_Btn?.setImage(UIImage(named: "heart-white 2"), for: .normal)
                 }
            }
        } else {
            if musicDetailDict.object(forKey: "musicPremium") != nil && musicDetailDict.object(forKey: "musicPremium") as! Int == 1
            {
                
            } else {
                if isFavourite == true
                {
                 isFavourite = false
                 db.insert(songId: (musicDetailDict.object(forKey: "musicID") as? String)!, updateStatus: "1")
                 heartIcon_Btn?.setImage(UIImage(named: "heart-Pink-2"), for: .normal)
                }
                 else
                {
                 isFavourite = true
                 self.db.deleteByID(id: (musicDetailDict.object(forKey: "musicID") as? String)!)
                 heartIcon_Btn?.setImage(UIImage(named: "heart-white 2"), for: .normal)
                 }
            }
        }
        UserDefaults.standard.setValue("yes", forKey: "fromFavourite")
    }
    
    
    @IBAction func playBtn_Action(_ sender: Any)
    {
        var duration : String = ""
        if let dur = musicDetailDict.object(forKey: "previewMp3Length")
        {
            duration = dur as! String
        }
        if isPlay == true {
            isPlay = false
            playBtn.setImage(UIImage(named: "stop"), for: .normal)
            guard let url = URL(string: musicDetailDict.object(forKey: "previewMp3") as! String)
                        else { return }
            
    //        let item = AVPlayerItem(url: url)
    //            let duration = Double(item.asset.duration.value) / Double(item.asset.duration.timescale)
    //        print(duration)

                    audioPlayer = AVPlayer(url: url as URL)
                    audioPlayer?.play()
            audioPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
                            if self.audioPlayer!.currentItem?.status == .readyToPlay {
                                let time : Float64 = CMTimeGetSeconds(self.audioPlayer!.currentTime());
                                print(time)
                                let currentTime = Int(time)
                                if !(duration == "")
                                {
                                    let totalDuration = Int(duration)
                                    let remainingTime = totalDuration! - currentTime
                                    self.timeDuration_Lbl.text = "0." + String(remainingTime)
                                }
                            }
                        }
            
            NotificationCenter.default.addObserver(self, selector: #selector(PreviewViewController.finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        } else {
            isPlay = true
            if let duration = musicDetailDict.object(forKey: "previewMp3Length")
            {
                timeDuration_Lbl.text = "0." + (duration as! String)
            }
            playBtn.setImage(UIImage(named: "play"), for: .normal)
            audioPlayer?.replaceCurrentItem(with: nil)
        }
    }
    
    @objc func finishVideo()
    {
        isPlay = true
        if let duration = musicDetailDict.object(forKey: "previewMp3Length")
        {
            timeDuration_Lbl.text = "0." + (duration as! String)
        }
        playBtn.setImage(UIImage(named: "play"), for: .normal)
    }
    
}

extension PreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return reviewArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    {
        let cell = collectionView_Ctrl.dequeueReusableCell(withReuseIdentifier: "Review", for: indexPath as IndexPath) as UICollectionViewCell
        let bgView = cell.viewWithTag(1)
       // let statusView = cell.viewWithTag(2)
        let userName = cell.viewWithTag(3) as? UILabel
        let description = cell.viewWithTag(4) as? UILabel
        let ratingImage = cell.viewWithTag(6) as? UIImageView
        let agoLbl = cell.viewWithTag(5) as? UILabel
        let singleDesLbl = cell.viewWithTag(7) as? UILabel
        
        bgView?.layer.cornerRadius = 12
        bgView?.clipsToBounds = true
        
        let tempDict = reviewArray.object(at: indexPath.row) as? NSDictionary
        
        userName?.text = tempDict?.object(forKey: "firstName") as? String ?? ""
        description?.text = tempDict?.object(forKey: "description") as? String ?? ""
        description?.sizeToFit()
        agoLbl?.text = tempDict?.object(forKey: "recencyText") as? String ?? ""
      
        if (description?.text!.count)! > 28
        {
            singleDesLbl?.isHidden = true
            description?.isHidden = false
        } else {
            singleDesLbl?.isHidden = false
            description?.isHidden = true
            singleDesLbl?.text = tempDict?.object(forKey: "description") as? String ?? ""
        }
        
        ratingImage!.layer.cornerRadius = (ratingImage?.frame.size.height)! / 2
        ratingImage!.clipsToBounds = true
        
        if let rating = tempDict?.object(forKey: "rating") as? Int
        {
            ratingImage?.isHidden = false
           if rating == 1
           {
            ratingImage?.image = UIImage(named: "1-colour (1)")
           } else if rating == 2 {
            ratingImage?.image = UIImage(named: "2-colour (1)")
           } else if rating == 3 {
            ratingImage?.image = UIImage(named: "3-colour (1)")
           } else if rating == 4 {
            ratingImage?.image = UIImage(named: "4-colour (1)")
           } else {
            ratingImage?.image = UIImage(named: "5-colour (1)")
           }
        } else {
            ratingImage?.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let tempDict = reviewArray.object(at: indexPath.row) as? NSDictionary
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReviewresponseViewController") as! ReviewresponseViewController
        vc.previewDetail = tempDict?.mutableCopy() as! NSDictionary
        vc.musicDetail = musicDetailDict
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    {
        return CGSize(width: 256, height: 154)
    }
    
   
}


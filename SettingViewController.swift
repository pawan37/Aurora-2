//
//  SettingViewController.swift
//  Aurora
//
//  Created by Augurs Technologies Pvt Ltd on 25/08/20.
//

import UIKit
import AVFoundation
import AVKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableview_Ctrl: UITableView!
    @IBOutlet weak var bgView_Ctrl: UIView!
    @IBOutlet weak var videoBg_Ctrl: UIView!
    let titleArray = ["Feedback","Manage downloads","","Rate us in the App Store","FAQs","Terms and Conditions","About"]
    var avPlayer: AVPlayer!
    var avpController = AVPlayerViewController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       // bgView_Ctrl.layer.cornerRadius = 30
     //   bgView_Ctrl.layer.maskedCorners = [.layerMinXMinYCorner]
    }
    
    @IBAction func downloadSwitch_Action(_ sender: UISwitch)
    {
        if sender.isOn == true
        {
            UserDefaults.standard.setValue("yes", forKey: "wifiOn")
        }
        else
        {
            UserDefaults.standard.setValue("no", forKey: "wifiOn")
        }
    }
    
    @IBAction func backBtn_Action(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SettingViewController : UITableViewDataSource, UITableViewDelegate

{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    
    {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    {
        let cell : UITableViewCell!
        if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "Setting2")
            let donloadSwitch = cell.viewWithTag(2) as? UISwitch
            if UserDefaults.standard.object(forKey: "wifiOn") != nil
            {
                if UserDefaults.standard.object(forKey: "wifiOn") as! String == "yes"
                {
                    donloadSwitch?.isOn = true
                }
                else
                {
                    donloadSwitch?.isOn = false
                }
            }
            else
            {
                donloadSwitch?.isOn = true
            }
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "Setting")
            let title = cell.viewWithTag(1) as? UILabel
            title?.text = titleArray[indexPath.row]
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 4
        {
           // guard let url = URL(string: "https://www.getmishi.com/app-faqs") else { return }
          //  UIApplication.shared.open(url)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            vc.url = "https://www.getmishi.com/app-faqs"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if indexPath.row == 5
        {
          //  guard let url = URL(string: "https://www.getmishi.com/app-terms") else { return }
         //   UIApplication.shared.open(url)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            vc.url = "https://www.getmishi.com/app-terms"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 3
        {
            guard let url = URL(string: "https://apps.apple.com/us/app/aurora-sleep-music/id1544762843") else { return }
            UIApplication.shared.open(url)
        }
        else if indexPath.row == 6
        {
          //  guard let url = URL(string: "https://www.getmishi.com/app-about") else { return }
          //  UIApplication.shared.open(url)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            vc.url = "https://www.getmishi.com/app-about"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 1
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageDownloadViewController") as! ManageDownloadViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 0
        {
          //  guard let url = URL(string: "https://www.getmishi.com/feedback") else { return }
           // UIApplication.shared.open(url)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            vc.url = "https://www.getmishi.com/feedback"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}



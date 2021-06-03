//
//  GameViewController.swift
//  Corona shooter
//
//  Created by alex on 9.06.20.
//  Copyright © 2020 alex. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
import Foundation
import FBSDKLoginKit
import FirebaseDatabase
import GoogleMobileAds
import Reachability
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

var bannerAdsTopId: String = "ca-app-pub-3940256099942544/6300978111"
var bannerAdsBottomId: String = "ca-app-pub-3940256099942544/6300978111"
var interstitialId: String = "ca-app-pub-3940256099942544/4411468910"

class GameViewController: UIViewController, LoginButtonDelegate, GADBannerViewDelegate, UIActionSheetDelegate {
    
    static var instance: GameViewController!
    var backingAudio: AVAudioPlayer!
    var interstitial: GADInterstitial!
    var request = GADRequest()
    var loginButton = FBLoginButton()    
    var defaults = UserDefaults()
    var token: String?

    
    // Facebook login
        
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        token = result?.token?.tokenString
        var parameters = ["fields":"email, name"]
        var request = FBSDKLoginKit.GraphRequest(graphPath: "me",parameters: parameters, tokenString: token, version: nil, httpMethod: .get)
        request.start(completionHandler: {connection, result, error in
        })
        if(token != nil){
            var defaults = UserDefaults()
            defaults.set(1, forKey: "loginType")
            getFacebookLoginData()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        var defaults = UserDefaults()
        defaults.set(0, forKey: "loginType")
        Animations.changeSceneAnimationWithDelay(fromScene: MainMenu.instance!, toScene: LogInScene.self, delay: 1)
        MainMenu.instance = nil
    }
            
    func loginButtonWillLogin(_ loginButton: FBLoginButton) -> Bool {
        return true
    }
    
    func getFacebookLoginData(){
        if var token = AccessToken.current, !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            var token = token.tokenString
            var parameters = ["fields":"email, name, picture.type(large)"]
            var request = FBSDKLoginKit.GraphRequest(graphPath: "me",parameters: parameters, tokenString: token, version: nil, httpMethod: .get)
            request.start(completionHandler: {connection, result, error in
                var data = result as! [String: Any]
                var picture = data["picture"] as! [String: Any]
                var email = data["email"]
                var name = data["name"]
                var pictureData = picture["data"] as! [String: Any]
                var url = URL(string: pictureData["url"] as! String)
                if var data = try? Data(contentsOf: url!){
                    FacebookLoginData.userPhoto = Utilities.maskRoundedImage(image: UIImage(data: data)!, radius: UIImage(data: data)!.size.width/2)
                    FacebookLoginData.fullName = name as? String
                    FacebookLoginData.email = email as? String
                    Utilities.SaveFacebookDataToDevice()
                    Utilities.LoadFacebookDataToDevice()
                    if(LogInScene.instance != nil){
                        Animations.changeSceneAnimationWithDelay(fromScene: LogInScene.instance!, toScene: MainMenuFacebookLogin.self, delay: 0)
                        LogInScene.instance = nil
                    }
                }
            })
        }
    }
                
    // Facebook login end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameViewController.instance = self
        
        // Firebase start

		let settings = FirestoreSettings()

		Firestore.firestore().settings = settings

		db = Firestore.firestore()

//        var ref = Database.database().reference()
//        ref.child("someid/name").setValue("Hello world")
//
        // firebase end
        
        // Facebook login button
        
        if var token = AccessToken.current, !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            var defaults = UserDefaults()
            defaults.set(1, forKey: "loginType")
        }
                        
        loginButton.delegate = self
        loginButton.permissions = ["public_profile", "email"]
        
        // Facebook login button end
        
        if var view = self.view as! SKView? {
            
            var filePath = Bundle.main.path(forResource: "font music", ofType: "mp3")
            var audioNSURL = URL(fileURLWithPath: filePath!)
            
            do{
                backingAudio = try AVAudioPlayer(contentsOf: audioNSURL)
            }
            catch{

            }
            
            backingAudio.numberOfLoops = -1
//            backingAudio.play()
            
            var deviceWidth = UIScreen.main.bounds.width * UIScreen.main.scale
            var deviceHeight = UIScreen.main.bounds.height * UIScreen.main.scale
            var DeviceAspectRatio = Double(deviceHeight / deviceWidth)
            
            var width = 1536.0
            var height = width * DeviceAspectRatio
            
            //        Google ads
            
            loadAds()
                        
            // Google ads
            
            // Load the SKScene from 'LoginWindow' width: 1536, height: 2048
            var menuForm = WelcomeScene(size: CGSize(width: width, height: height))
            // Set the scale mode to scale to fit the window
                                    
//            menuForm.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(menuForm)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }
        
    // google ads delegates
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {

    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {

    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {

    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {

    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {

    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {

    }
    
    // end google ads delegates
    
    
    func loadAds(){
        interstitial = GADInterstitial(adUnitID: interstitialId )
        interstitial.load(request)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func ShowCustomLogOut(fromScene: SKScene, toScene: SKScene.Type)
    {
        var optionMenu = UIAlertController(title: nil, message: "Logged in as Guess", preferredStyle: .actionSheet)
        var logOutAction = UIAlertAction(title: "Log out", style: .destructive, handler:
        {
            (alert: UIAlertAction!) -> Void in
            var defaults = UserDefaults()
            defaults.set(0, forKey: "loginType")
            Animations.changeSceneAnimationWithDelay(fromScene: fromScene, toScene: toScene, delay: 0)
        })
        
        var cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in            
        })
        optionMenu.addAction(logOutAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func checkInternetConnection(){
        let reachability = try! Reachability()
        switch reachability.isReachable {
            case true:
                loginButton.sendActions(for: .touchUpInside)
            break
            case false:
                let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            break
            default:
            break
        }
    }
}

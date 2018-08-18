//
//  HomeViewController.swift
//  Slash
//
//  Created by Michael Lema on 8/16/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import GDAXSocketSwift

class HomeViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    static let coinCellId = "cellId"

    var interval: TimeInterval!
    var timer: Timer!
    var firstPrice = ""
    var secondPrice = ""
    var thirdPrice = ""
    var fourthPrice = ""
    var fifthPrice = ""
    
    var pairs = [Pair]()
    
    var firstPairID: String!
    var secondPairID: String!
    var thirdPairID: String!
    var fourthPairID: String!
    var fifthPairID: String!
    
    var chosenPairs: [Pair] = []
    var reachability: Reachability?
    var fontPosistive: NSMutableAttributedString!
    var fontNegative: NSMutableAttributedString!
    var font:  [String : NSObject]!
    var useColouredSymbols = true
    
    let defaults = Foundation.UserDefaults.standard
    let pairsURL = "https://api.pro.coinbase.com/"
    let green = UIColor.init(red: 22/256, green: 206/255, blue: 0/256, alpha: 1)
    let red = UIColor.init(red: 255/256, green: 73/255, blue: 0/256, alpha: 1)
    let white = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
    
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CoinCell.self, forCellWithReuseIdentifier: HomeViewController.coinCellId)
        return collectionView
    }()
    
    var settingsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "settings").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func settingsTapped() {
        //: Button animation
        UIView.animate(withDuration: 0.2, animations: {
            self.settingsButton.transform = CGAffineTransform(scaleX: 0.92, y: 0.96)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.settingsButton.transform = CGAffineTransform.identity
            })
        }
        //: FIXME: BRing up a tableViewController later
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.35, green:0.54, blue:0.90, alpha:1.0)
        self.view.addSubview(collectionView)
        self.view.addSubview(settingsButton)
        
        settingsButton.anchor(top: view.topAnchor, bottom: nil, left: nil, right: view.rightAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 0, paddingRight: 10, width: 25, height: 25)
        collectionView.anchor(top: nil, bottom: self.view.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingBottom: -70, paddingLeft: 0, paddingRight: 0, width: 0, height: (self.view.frame.height / 2))
    }
    

    
    func updateTimer() {
        if timer != nil {
            if timer.isValid == true {
                timer.invalidate()
            }
        }
        
       // timer = Timer(timeInterval: interval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }

    
    
    func updateInterval(_ interval: TimeInterval) {
        self.interval = interval
        
        defaults.set(self.interval, forKey: UserDefaults.interval.rawValue)
        defaults.synchronize()
        
        updateTimer()
    }
    

    //: MARK: CollectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.coinCellId, for: indexPath) as! CoinCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 60), height: (self.view.frame.height / 2))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //: Adjust the cell position
        let width = self.view.frame.width
        let cellWidth = (self.view.frame.width - 60)
        let diff = (width-cellWidth) / 2
        return UIEdgeInsets(top: 0, left: diff, bottom: 0, right: diff)
    }


}

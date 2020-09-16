//
//  SeatViewController.swift
//  seatTicketing
//
//  Created by 김수완 on 2020/08/15.
//  Copyright © 2020 김수완. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SeatViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mySeat: UIButton!
    
    
    var ref : DatabaseReference!
    
    var seats : [String] = []
    var selectedCell : Int = -1
    var didSelected : Bool = false
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        super.viewDidLoad()
        
        for _ in 0 ..< max{
            seats.append("")
        }
        
        self.setSeats()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        
        ref.observe(DataEventType.childChanged, with: { _ in
            self.setSeats()
        })
    }
    
    func setSeats() {
        ref = Database.database().reference()
        for i in 0 ..< max {
            self.ref.child(code+"/seat/"+String(i)).observeSingleEvent(of: .value) { snapshotSeat in
                let whoSeat = snapshotSeat.value as? String ?? ""
                if whoSeat != "" {
                    self.seats[i] = whoSeat
                    self.collectionView.reloadData()
                }
                if self.seats.contains(myName){
                    self.didSelected = true
                    self.mySeat.isEnabled = false
                    self.mySeat.setImage(UIImage(named: "Btn02_off"), for: .normal)
                }
                else{
                    self.didSelected = false
                    self.mySeat.isEnabled = true
                    self.mySeat.setImage(UIImage(named: "Btn02_on"), for: .normal)
                }
                    

            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatViewCell", for: indexPath) as! seatViewCell
        
        cell.CellLable.text = seats[indexPath.row]
        if seats[indexPath.row] == "" {
            if selectedCell == indexPath.row {
                cell.CellImage.image = UIImage(named: "cellDidSelected")
            }
            else{
                cell.CellImage.image = UIImage(named: "standardCell")
            }
        }
        else{
            if selectedCell == indexPath.row {
                selectedCell = -1
            }
            cell.CellImage.image = UIImage(named: "cellDidTooken")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if seats[indexPath.row] == "" && didSelected == false{
            selectedCell = indexPath.row
            self.collectionView.reloadData()
        }
        
    }

    @IBAction func mySeat(_ sender: UIButton) {
        if selectedCell != -1 {
            ref = Database.database().reference()
            let Out = self.ref.child(code+"/seat/"+String(selectedCell))
            Out.setValue(myName)
        }
        
    }
    
    
    
    // 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let collectionViewCellWithd = collectionView.frame.width / 4 - 5
        return CGSize(width: collectionViewCellWithd, height: collectionViewCellWithd)
    }

    //위아래 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    //옆 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

}

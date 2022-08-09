//
//  UrlTableViewCell.swift
//  DownloadManagerIII
//
//  Created by Adel Al-Aali on 6/28/22.
//

import UIKit
import SwiftSoup

@IBDesignable class UrlTableViewCell: UITableViewCell
{
	
    internal var hrefLinks: [Element]? {
        didSet {
            titleLbl.text = hrefLinks?.description.self
        }
    }
    
    @IBAction func sendBtnPressed(){
        print("[!] Initiating send btn pressed")
        
    }
    
    private let titleLbl : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .systemIndigo
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cellid")
        addSubview(titleLbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

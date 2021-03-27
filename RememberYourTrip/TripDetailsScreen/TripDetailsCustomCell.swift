//
//  TripDetailsCustomCell.swift
//  RememberYourTrip
//
//  Created by Alexey Onoprienko on 27.03.2021.
//

import UIKit

class TripDetailsCustomCell: UITableViewCell {
    
    var place: Details? {
        didSet {
            guard let placeName = place?.place else { return }
            placeNameLabel.text = placeName
            
            guard let placeComment = place?.impression else { return }
            commentTextView.isHidden = false
            commentTextView.text = placeComment
        }
    }
    
    let placeNameLabel : UILabel = {
       let label = UILabel()
        label.text = "text"
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    let commentTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .tealColor
        textView.textColor = .white
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isHidden = true
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tealColor
        setupUI()
    }
    
    private func setupUI() {
        addSubview(placeNameLabel)
        placeNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 16, paddingBottom: 10, paddingRight: 0, width: 80, height: 0)

        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: placeNameLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

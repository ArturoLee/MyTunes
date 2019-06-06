//
//  MediaTableViewCell.swift
//  MyTunes
//
//  Created by Arturo Lee on 6/5/19.
//  Copyright © 2019 Arturo Lee. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {
    
    var media: MusicMedia? {
        didSet {
            guard let musicMedia = media else {return}
            titleLabel.text = musicMedia.name
            subTitleLabel.text = musicMedia.artistName
            coverImageView.image = musicMedia.image
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let stackView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = UIStackView.Alignment.leading
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.stackView.addArrangedSubview(titleLabel)
        self.stackView.addArrangedSubview(subTitleLabel)
        self.contentView.addSubview(coverImageView)
        self.contentView.addSubview(stackView)
        
        coverImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        coverImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor).isActive = true
        coverImageView.widthAnchor.constraint(equalToConstant:100).isActive = true
        coverImageView.heightAnchor.constraint(equalToConstant:100).isActive = true
        
        stackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.coverImageView.trailingAnchor, constant: 15).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

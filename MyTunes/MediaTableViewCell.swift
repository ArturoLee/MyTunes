//
//  MediaTableViewCell.swift
//  MyTunes
//
//  Created by Arturo Lee on 6/5/19.
//  Copyright © 2019 Arturo Lee. All rights reserved.
//

import UIKit
import UIImageColors

class MediaTableViewCell: UITableViewCell {
    
    var media: MusicMedia? {
        didSet {
            guard let musicMedia = media else {return}
            titleLabel.text = musicMedia.media.name
            subTitleLabel.text = musicMedia.media.artistName
            coverImageView.image = musicMedia.image
            colorizeViews(mediaColors: musicMedia.colors)
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
    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
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
        self.contentView.addSubview(rankLabel)
        
        coverImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        coverImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor).isActive = true
        coverImageView.widthAnchor.constraint(equalToConstant:100).isActive = true
        coverImageView.heightAnchor.constraint(equalToConstant:100).isActive = true
        
        rankLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        rankLabel.leadingAnchor.constraint(equalTo: self.coverImageView.trailingAnchor, constant: 10).isActive = true
        
        stackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.rankLabel.trailingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
    }
    
    func colorizeViews(mediaColors: UIImageColors?) {
        guard let colors = mediaColors else {
            backgroundColor = .white
            titleLabel.textColor = .black
            subTitleLabel.textColor = .black
            rankLabel.textColor = .black
            return
        }
        self.backgroundColor = colors.background
        self.titleLabel.textColor = colors.primary
        self.subTitleLabel.textColor = colors.secondary
        self.rankLabel.textColor = colors.detail
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

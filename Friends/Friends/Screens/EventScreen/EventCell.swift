//
//  EventCell.swift
//  Friends
//
//  Created by Алексей on 26.03.2025.
//

import Foundation
import UIKit
import MapKit

final class EventCell: UITableViewCell {
    // MARK: - Constants
    private enum Constants {
        static let wrapOffsetV: CGFloat = 5
        static let wrapRadius: CGFloat = 20
        
        static let imageViewWidth: CGFloat = 140
        static let imageViewOffset: CGFloat = 10
        static let imageRadius: CGFloat = 9
        
        static let titleOffsetH: CGFloat = 25
        static let titleHeight: CGFloat = 35
        static let titleFont: UIFont = .systemFont(ofSize: 24)
        
        static let infoLabelHeight: CGFloat = 16
        static let infoLabelFont: UIFont = .systemFont(ofSize: 12)
        static let infoRadius: CGFloat = 5
        static let infoOffsetTop: CGFloat = 5
        
        static let friendsImagesSize: CGFloat = 25
        static let friendsImagesRadius: CGFloat = 12.5
        
        static let counterFont: UIFont = .systemFont(ofSize: 10)
        
        static let overlapOffset: CGFloat = 12
        
        static let awaitingStatusImage: UIImage? = UIImage(systemName: "questionmark.circle.fill")
        static let goingStatusImage: UIImage? = UIImage(systemName: "checkmark.circle.fill")
        static let declinedStatusImage: UIImage? = UIImage(systemName: "x.circle.fill")
        static let statusImageSize: CGFloat = 12
        static let statusImageOffsetBottom: CGFloat = 12
        static let statusImageOffsetRight: CGFloat = 15
        
        static let statusLabelOffsetLeft: CGFloat = 2
    }
    
    // MARK: - Properties
    static let reuseIdentifier: String = "EventCell"
        
    private let wrapView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let addressLabel: UILabel = UILabel()
    private let dateLabel: UILabel = UILabel()
    private let image: UIImageView = UIImageView()
    private let mapView: MKMapView = MKMapView()
    private let friendsImageViews: [UIImageView] = [
        UIImageView(),
        UIImageView(),
        UIImageView()
    ]
    private let statusLabel: UILabel = UILabel()
    private let statusImageView: UIImageView = UIImageView()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    private func configureUI() {
        backgroundColor = .clear
        selectionStyle = .none
        configureWrap()
        configureImage()
        configureTitleLabel()
        configureAddressLabel()
        configureDateLabel()
        configureFriendsImages()
        configureStatus()
    }
    
    // MARK: - Cell Configuration
    func configure(with event: EventModel) {
        
        titleLabel.text = event.title
        addressLabel.text = event.address
        dateLabel.text = event.date
        for ind in 0..<event.friendsImages.count {
            if ind == 3 {
                configureExtraFriends(with: event)
                break
            }
            friendsImageViews[ind].image = event.friendsImages[ind]
        }
        switch event.goingStatus {
        case .awaiting:
            statusLabel.text = "slide to accept"
            statusLabel.textColor = .systemOrange
            statusImageView.image = Constants.awaitingStatusImage
            statusImageView.tintColor = .systemOrange
        case .going:
            statusLabel.text = "going"
            statusLabel.textColor = .systemGreen
            statusImageView.image = Constants.goingStatusImage
            statusImageView.tintColor = .systemGreen
        case .declined:
            statusLabel.text = "declined"
            statusLabel.textColor = .systemRed
            statusImageView.image = Constants.declinedStatusImage
            statusImageView.tintColor = .systemRed
        }
        configureRegion(with: event)
    }
    
    // MARK: - UI Configuration
    private func configureWrap() {
        contentView.addSubview(wrapView)
        wrapView.backgroundColor = .white
        wrapView.layer.cornerRadius = Constants.wrapRadius
        
        wrapView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(Constants.wrapOffsetV)
            make.leading.trailing.equalTo(contentView)
        }
    }
    
    private func configureImage() {
        wrapView.addSubview(image)
        image.snp.makeConstraints { make in
            make.width.equalTo(Constants.imageViewWidth)
            make.leading.equalTo(wrapView.snp.leading).offset(Constants.imageViewOffset)
            make.top.bottom.equalTo(wrapView).inset(Constants.imageViewOffset)
        }
    }

    private func configureRegion(with event: EventModel) {
        mapView.frame = image.bounds
        mapView.layer.cornerRadius = Constants.imageRadius
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        image.addSubview(mapView)
           
        let region = event.region
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = event.location
        annotation.title = "Место"
        mapView.addAnnotation(annotation)
    }
    
    private func configureTitleLabel() {
        wrapView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(Constants.titleOffsetH)
            make.trailing.equalTo(wrapView.snp.trailing).offset(-Constants.titleOffsetH)
            make.height.equalTo(Constants.titleHeight)
            make.top.equalTo(image.snp.top)
        }

        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = Constants.titleFont
    }
    
    private func configureAddressLabel() {
        wrapView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(Constants.titleOffsetH)
            make.trailing.equalTo(titleLabel.snp.trailing).offset(Constants.titleOffsetH)
            make.height.equalTo(Constants.infoLabelHeight)
            make.top.equalTo(titleLabel.snp.bottom)
        }

        addressLabel.textColor = .gray
        addressLabel.textAlignment = .left
        addressLabel.font = Constants.infoLabelFont
    }
    
    private func configureDateLabel() {
        wrapView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(Constants.titleOffsetH)
            make.trailing.equalTo(addressLabel.snp.trailing).offset(Constants.titleOffsetH)
            make.height.equalTo(Constants.infoLabelHeight)
            make.top.equalTo(addressLabel.snp.bottom)
        }

        dateLabel.textColor = .gray
        dateLabel.textAlignment = .left
        dateLabel.font = Constants.infoLabelFont
    }
    
    private func configureFriendsImages() {
        let firstFriendImageView = friendsImageViews[0]
        wrapView.addSubview(firstFriendImageView)
        firstFriendImageView.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(Constants.titleOffsetH)
            make.bottom.equalTo(wrapView.snp.bottom).inset(Constants.imageViewOffset)
        }

        for ind in 0..<friendsImageViews.count {
            if ind != 0 {
                let newFirstFriendImageView = friendsImageViews[ind]
                wrapView.addSubview(newFirstFriendImageView)
                newFirstFriendImageView.snp.makeConstraints { make in
                    make.leading.equalTo(friendsImageViews[ind - 1].snp.trailing).offset(-Constants.overlapOffset)
                    make.bottom.equalTo(wrapView.snp.bottom).inset(Constants.imageViewOffset)
                }

            }
            friendsImageViews[ind].snp.makeConstraints { make in
                make.width.equalTo(Constants.friendsImagesSize)
                make.height.equalTo(Constants.friendsImagesSize)
            }
            friendsImageViews[ind].layer.cornerRadius = Constants.friendsImagesRadius
            friendsImageViews[ind].backgroundColor = .clear
        }
    }
    
    private func configureExtraFriends(with event: EventModel) {
        let extraFriendView = UIView()
        wrapView.addSubview(extraFriendView)
        extraFriendView.snp.makeConstraints { make in
            make.width.equalTo(Constants.friendsImagesSize)
            make.height.equalTo(Constants.friendsImagesSize)
        }
        extraFriendView.layer.cornerRadius = Constants.friendsImagesRadius
        extraFriendView.backgroundColor = UIColor.extraFriendsBackground
        extraFriendView.snp.makeConstraints { make in
            make.leading.equalTo(friendsImageViews[2].snp.trailing).offset(-Constants.overlapOffset)
            make.bottom.equalTo(wrapView.snp.bottom).inset(Constants.imageViewOffset)
        }

        let counter = UILabel()
        counter.text = "+" + String(event.friendsImages.count - (friendsImageViews.count))
        counter.textColor = .gray
        counter.font = Constants.counterFont
        counter.textAlignment = .center
        extraFriendView.addSubview(counter)
        counter.snp.makeConstraints { make in
            make.center.equalTo(extraFriendView)
        }
    }
    
    private func configureStatus() {
        wrapView.addSubview(statusImageView)
            
        statusImageView.snp.makeConstraints { make in
            make.trailing.equalTo(wrapView.snp.trailing).inset(Constants.statusImageOffsetRight)
            make.bottom.equalTo(wrapView.snp.bottom).inset(Constants.statusImageOffsetBottom)
            make.height.equalTo(Constants.statusImageSize)
            make.width.equalTo(Constants.statusImageSize)
        }
        
        wrapView.addSubview(statusLabel)
        
        statusLabel.textAlignment = .right
        statusLabel.font = Constants.infoLabelFont
        statusLabel.numberOfLines = 1
            
        statusLabel.snp.makeConstraints { make in
            make.trailing.equalTo(statusImageView.snp.leading).inset(-Constants.statusLabelOffsetLeft)
            make.bottom.equalTo(wrapView.snp.bottom).inset(Constants.imageViewOffset)
            make.height.equalTo(Constants.infoLabelHeight)
        }
       
        let leadingConstraint = statusLabel
            .leadingAnchor
            .constraint(greaterThanOrEqualTo: image.trailingAnchor,
                        constant: Constants.titleOffsetH)

        leadingConstraint.priority = .defaultLow
        leadingConstraint.isActive = true
    }
}

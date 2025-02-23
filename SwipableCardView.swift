//
//  SwipeableCardView.swift
// Wali Faisal
//

import UIKit

protocol SwipeableCardDelegate: AnyObject {
    func cardDidSwipe(_ card: SwipeableCardView)
}

class SwipeableCardView: UIView {
    
    weak var delegate: SwipeableCardDelegate?
    private var initialCenter: CGPoint = .zero
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return iv
    }()
    
    private let infoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .yellow
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let startsInLabel: UILabel = {
        let label = UILabel()
        label.textColor = .yellow
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let verifiedBadge: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.8)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: "checkmark.seal.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        iconImageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.text = "Verified"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .bold)
        
        view.addSubview(iconImageView)
        view.addSubview(label)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 14),
            iconImageView.heightAnchor.constraint(equalToConstant: 14),
            
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    private let chevronContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 20 // Circular shape
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()

    private let chevronIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    private let grayOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.alpha = 0.3
        view.isUserInteractionEnabled = false
        return view
    }()

    
 
    


    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        addPanGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
        addPanGesture()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 6
        self.clipsToBounds = true
    }
    
    private func setupLayout() {
        // Add subviews
        addSubview(imageView)
        addSubview(infoContainer)
        infoContainer.addSubview(titleLabel)
        infoContainer.addSubview(detailsLabel)
        infoContainer.addSubview(locationLabel)
        infoContainer.addSubview(startsInLabel)
        addSubview(verifiedBadge)
        addSubview(chevronContainer)
        chevronContainer.addSubview(chevronIcon)
     
        addSubview(grayOverlay)
       
        
        // Setup constraints using frame-based layout for better performance
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height * 0.7)
        
        let infoHeight: CGFloat = frame.height * 0.3
        infoContainer.frame = CGRect(x: 0, y: frame.height - infoHeight, width: frame.width, height: infoHeight)
        
        let padding: CGFloat = 12
        titleLabel.frame = CGRect(x: padding, y: padding, width: frame.width - 2 * padding, height: 22)
        detailsLabel.frame = CGRect(x: padding, y: titleLabel.frame.maxY + 4, width: frame.width - 2 * padding, height: 20)
        locationLabel.frame = CGRect(x: padding, y: detailsLabel.frame.maxY + 4, width: frame.width - 2 * padding, height: 20)
        startsInLabel.frame = CGRect(x: padding, y: locationLabel.frame.maxY + 4, width: frame.width - 2 * padding, height: 20)
        
        verifiedBadge.frame = CGRect(x: frame.width - 100, y: 25, width: 80, height: 24)
        

        let size: CGFloat = 40
        chevronContainer.frame = CGRect(x: frame.width - size - 20, y: frame.height - size - 20, width: size, height: size)
        chevronIcon.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        
        grayOverlay.frame = self.bounds
    }
    
    func configure(with event: EventInfo) {
        imageView.image = event.image
        titleLabel.text = event.title
        
        // MARK: - Location Label (White + Yellow)
        let locationText = "Location: "
        let eventLocationText = "\(event.location)"
        
        let locationAttributedString = NSMutableAttributedString(
            string: locationText,
            attributes: [.foregroundColor: UIColor.white]
        )
        
        let eventLocationAttributedString = NSAttributedString(
            string: eventLocationText,
            attributes: [.foregroundColor: UIColor.yellow]
        )
        
        locationAttributedString.append(eventLocationAttributedString)
        locationLabel.attributedText = locationAttributedString

        // MARK: - Starts In Label (Clock Icon + White + Yellow)
        let startsText = "Starts in: "
        let startsAttributedString = NSMutableAttributedString(
            string: startsText,
            attributes: [.foregroundColor: UIColor.white]
        )

        let clockAttachment = NSTextAttachment()
        let clockImage = UIImage(systemName: "clock.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        clockAttachment.image = clockImage
        clockAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)

        let clockAttributedString = NSAttributedString(attachment: clockAttachment)
        startsAttributedString.append(clockAttributedString)

        let timeText = " \(event.startsIn)hrs"
        let timeAttributedString = NSAttributedString(
            string: timeText,
            attributes: [.foregroundColor: UIColor.yellow]
        )

        startsAttributedString.append(timeAttributedString)
        startsInLabel.attributedText = startsAttributedString

        // MARK: - Details Label (Dollar Icon + Clock Icon + User Icon)
        let detailsAttributedString = NSMutableAttributedString()

        // Dollar symbol
        let dollarAttachment = NSTextAttachment()
        dollarAttachment.image = UIImage(systemName: "dollarsign.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        dollarAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        detailsAttributedString.append(NSAttributedString(attachment: dollarAttachment))

        // Price text
        let priceText = " \(event.price) • "
        detailsAttributedString.append(NSAttributedString(
            string: priceText,
            attributes: [.foregroundColor: UIColor.yellow]
        ))

        // Clock symbol
        let timeAttachment = NSTextAttachment()
        timeAttachment.image = UIImage(systemName: "clock.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        timeAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        detailsAttributedString.append(NSAttributedString(attachment: timeAttachment))

        // Time text
        let timeDetailText = " \(event.time) • "
        detailsAttributedString.append(NSAttributedString(
            string: timeDetailText,
            attributes: [.foregroundColor: UIColor.yellow]
        ))

        // User symbol
        let userAttachment = NSTextAttachment()
        userAttachment.image = UIImage(systemName: "person.2.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        userAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        detailsAttributedString.append(NSAttributedString(attachment: userAttachment))

        // Guests text
        let guestsText = " \(event.guests) guests"
        detailsAttributedString.append(NSAttributedString(
            string: guestsText,
            attributes: [.foregroundColor: UIColor.yellow]
        ))

        detailsLabel.attributedText = detailsAttributedString
    }



    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    

    
    func rotateChevron() {
        UIView.animateKeyframes(withDuration: 1, delay: 0.2, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                self.chevronIcon.transform = CGAffineTransform(rotationAngle: .pi / 2)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                self.chevronIcon.transform = CGAffineTransform(rotationAngle: .pi)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25) {
                self.chevronIcon.transform = CGAffineTransform(rotationAngle: 3 * .pi / 2)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                self.chevronIcon.transform = CGAffineTransform(rotationAngle: .pi * 2)
            }
        }, completion: nil)
    }

    
    
    private func getNextCard() -> SwipeableCardView? {
        guard let superview = self.superview else { return nil }
        
        let otherCards = superview.subviews.compactMap { $0 as? SwipeableCardView }
        let sortedCards = otherCards.sorted { $0.frame.origin.y < $1.frame.origin.y }
        
        if let currentIndex = sortedCards.firstIndex(of: self), currentIndex + 1 < sortedCards.count {
            return sortedCards[currentIndex + 1]
        }
        
        return nil
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: superview)
        let velocity = gesture.velocity(in: superview)
        
        switch gesture.state {
        case .began:
            initialCenter = self.center
            superview?.bringSubviewToFront(self)
            
        case .changed:
            // Restrict movement to horizontal axis only
            self.center.x = initialCenter.x + translation.x
            let rotationAngle = (translation.x / 200) * CGFloat.pi / 8
            self.transform = CGAffineTransform(rotationAngle: rotationAngle)
            
        case .ended:
            let swipeThreshold: CGFloat = 100
            if abs(translation.x) > swipeThreshold || abs(velocity.x) > 500 {
                let direction: CGFloat = translation.x > 0 ? 1 : -1
                UIView.animate(withDuration: 0.3, animations: {
                    self.center.x += direction * 500
                    self.alpha = 0
                }) { _ in
                    if let nextCard = self.getNextCard() {
                        nextCard.rotateChevron()
                    }
                    self.removeFromSuperview()
                    self.delegate?.cardDidSwipe(self)
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.center = self.initialCenter
                    self.transform = .identity
                }
            }
            
        default:
            break
        }
    }


    
    func applyOverlay() {
        grayOverlay.alpha = 0.7
        chevronContainer.alpha = 0
      }
    
    func removeOverlay(animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0) {
                self.grayOverlay.alpha = 0
                self.chevronContainer.alpha = 1
            }
        } else {
            grayOverlay.alpha = 0
            chevronContainer.alpha = 0
        }
    }
    
    
}

// Event data model
struct EventInfo {
    let image: UIImage
    let title: String
    let location: String
    let price: String
    let time: String
    let guests: Int
    let startsIn: Int 
}

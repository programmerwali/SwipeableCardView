//
//  ViewController.swift
//  Wali Faisal
//

import UIKit

class ViewController: UIViewController, SwipeableCardDelegate {
    
    private var cardStack: [SwipeableCardView] = []
    private let verticalOffset: CGFloat = 65
    private let cardWidth: CGFloat = 320
    private let cardHeight: CGFloat = 530
    private let scaleDecrement: CGFloat = 0.08  // Adjusted scale decrement
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwipeableCards()
    }
    private var events: [EventInfo] = [] // Store all events
    private var displayedCards: [SwipeableCardView] = [] // Only store three visible cards
    private var nextCardIndex = 3 // Track the next card to be loaded
    
    private func setupSwipeableCards() {
        events = [
            EventInfo(image: UIImage(named: "event1") ?? UIImage(),
                      title: "Yoga Workshop",
                      location: "Garden town Lahore, PK",
                      price: "$100.0",
                      time: "23:59-0:0",
                      guests: 24,
                      startsIn: 7),
            EventInfo(image: UIImage(named: "event2") ?? UIImage(),
                      title: "Meditation Session",
                      location: "Gulshan, Dhaka, BD",
                      price: "$80.0",
                      time: "18:00-20:00",
                      guests: 15,
                      startsIn: 5),
            EventInfo(image: UIImage(named: "event3") ?? UIImage(),
                      title: "Dance Workshop",
                      location: "Delhi, Delhi, IN",
                      price: "$120.0",
                      time: "14:00-16:00",
                      guests: 30,
                      startsIn: 19),
            EventInfo(image: UIImage(named: "event4") ?? UIImage(),
                      title: "Art Exhibition",
                      location: "Askari, Islamabad, PK",
                      price: "$50.0",
                      time: "10:00-18:00",
                      guests: 100,
                      startsIn: 3),
            EventInfo(image: UIImage(named: "event5") ?? UIImage(),
                      title: "Music Concert",
                      location: "Chennai, Tamil Nadu, IN",
                      price: "$150.0",
                      time: "20:00-23:00",
                      guests: 200,
                      startsIn: 6)
        ]
        
        displayedCards.removeAll()
        nextCardIndex = 3 // Start tracking after the first three cards
        
        for i in 0..<min(3, events.count) {
            addCardToView(forIndex: i)
        }
        
        layoutCards(displayedCards, animated: false)
    }
    
    private func addCardToView(forIndex index: Int) {
        guard index < events.count else { return }
        
        let centerX = view.bounds.width / 2
        let safeAreaTop = view.safeAreaInsets.top
        let marginFromTop: CGFloat = 300
        let startY = safeAreaTop + marginFromTop + (CGFloat(displayedCards.count) * verticalOffset)
        
        let card = SwipeableCardView(frame: CGRect(x: centerX - (cardWidth / 2),
                                                   y: startY,
                                                   width: cardWidth,
                                                   height: cardHeight))
        card.configure(with: events[index])
        card.delegate = self
        card.isUserInteractionEnabled = (displayedCards.isEmpty)
        
        if displayedCards.isEmpty {
            card.removeOverlay(animated: false)
        } else {
            card.applyOverlay()
        }
        
        displayedCards.append(card)
        view.insertSubview(card, at: 0)
    }
    

    
    func cardDidSwipe(_ card: SwipeableCardView) {
        if let index = displayedCards.firstIndex(of: card) {
            displayedCards.remove(at: index)

            // Animate the card fading out and shrinking before removal
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                card.alpha = 0
                card.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { _ in
                card.removeFromSuperview()
            }

            if let topCard = displayedCards.first {
                topCard.isUserInteractionEnabled = true
                topCard.removeOverlay(animated: true)
            }

            // Silent refill logic: Add a new card at the back before updating layout
            if displayedCards.count < 3 {
                let nextIndex = nextCardIndex % events.count
                let newCard = createCard(forIndex: nextIndex)
                displayedCards.append(newCard)
                view.insertSubview(newCard, at: 0) // Add behind existing cards

                // Fade-in effect for newly added card
                newCard.alpha = 0
                UIView.animate(withDuration: 0.25, delay: 0.2, options: .curveEaseInOut) {
                    newCard.alpha = 1
                }
                
                nextCardIndex += 1
            }

            layoutCards(displayedCards, animated: true) // Apply smooth shifting animation
        }
    }


    // Helper function to create a new card silently
    private func createCard(forIndex index: Int) -> SwipeableCardView {
        let centerX = view.bounds.width / 2
        let baseYPosition: CGFloat = 100 + (CGFloat(displayedCards.count) * verticalOffset)

        let card = SwipeableCardView(frame: CGRect(x: centerX - (cardWidth / 2),
                                                   y: baseYPosition,
                                                   width: cardWidth,
                                                   height: cardHeight))
        card.configure(with: events[index])
        card.delegate = self
        card.isUserInteractionEnabled = false
        card.applyOverlay() //overlay until it's moved up in the stack

        return card
    }

    
    // Layout logic to maintain max 3 visible cards
    private func layoutCards(_ cards: [SwipeableCardView], animated: Bool) {
        let cardSpacing: CGFloat = 55
        let scaleFactor: CGFloat = scaleDecrement
        let centerX = view.bounds.width / 2
        let baseYPosition: CGFloat = 100
        
        for (index, card) in cards.enumerated() {
            let scale = 1.0 - (CGFloat(index) * scaleFactor)
            let yOffset = CGFloat(index) * cardSpacing
            let newCenter = CGPoint(x: centerX, y: baseYPosition + yOffset + (cardHeight / 2))
            
            let transform = CGAffineTransform(scaleX: scale, y: scale)
            
            if animated {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                    card.transform = transform
                    card.center = newCenter
                }
            } else {
                card.transform = transform
                card.center = newCenter
            }
        }
    }
}

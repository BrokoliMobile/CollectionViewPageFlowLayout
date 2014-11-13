//
//  CollectionViewPageFlowLayout.swift
//  Mansetler
//
//  Created by Seyithan on 12/11/14.
//  Copyright (c) 2014 Brokoli. All rights reserved.
//

import UIKit

class CollectionViewPageFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Init
    
    override init() {
        super.init()
        
        /*  Default minimum line spacing is 0. Makes pages appear stuck to each other.
         *  
         *  Set this property to non-zero and extend your collectionView's frame beyond
         *  it's container view to make it look like the pages have separators around
         *  them, as such:
         *  
         *  self.collectionView.frame = CGRectInset(self.view.bounds, -2, -2)
         *  let pageLayout = self.collectionViewLayout as CollectionViewPageFlowLayout
         *  pageLayout.minimumLineSpacing = 2
         */
        self.minimumLineSpacing = 0
        
        /*  Swift does not call `willSet` or `didSet` when you set a property inside
         *  any init method. So we have to manually call configure section insets method.
         */
        self.configureSectionInsetsBasedOnLineSpacing()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /*  Call configure section instes in case the minimum line spacing is set via
         *  interface builder.
         */
        self.configureSectionInsetsBasedOnLineSpacing()
    }
    
    // MARK: - Variable observations
    
    override var minimumLineSpacing: CGFloat {
        didSet {
            
            /* Call configure section insets every time the minimum line spacing is changed.
             */
            self.configureSectionInsetsBasedOnLineSpacing()
        }
    }
    
    // MARK: - Override layout
    
    override func prepareLayout() {
        if let collectionView = self.collectionView {
            collectionView.pagingEnabled = true
            self.scrollDirection = .Horizontal
            
            /*  Get the size of the collection view and fit the items into it to make them
             *  appear as _pages_.
             */
            let viewSize = collectionView.bounds.size
            resetItemSizeWithViewSize(viewSize)
        }
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        resetItemSizeWithViewSize(newBounds.size)
        return !CGRectEqualToRect(self.collectionView!.bounds, newBounds)
    }
    
    // MARK: - Content offset presistance
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        
        /*  Needed to keep the collectionView on the same _page_ when it's bounds change
         */
        if let collectionView = self.collectionView {
            if let indexPath = collectionView.indexPathsForVisibleItems().first as NSIndexPath? {
                let attributes = self.layoutAttributesForItemAtIndexPath(indexPath)
                var origin = attributes.frame.origin
                origin.x -= self.minimumLineSpacing / 2
                return origin
            }
        }
        return proposedContentOffset
    }
    
    // MARK: - Private functions
    
    private func resetItemSizeWithViewSize(viewSize: CGSize) {
        let itemSize = CGSize(width: viewSize.width - minimumLineSpacing, height: viewSize.height)
        self.itemSize = itemSize
    }
    
    private func configureSectionInsetsBasedOnLineSpacing() {

        /*  Set the section inset's left and right properties to minimumLineSpacing / 2
         *  to keep the _pages_ in the center of the collectionView's viewport.
         */
        self.sectionInset = UIEdgeInsets(top: 0, left: minimumLineSpacing / 2, bottom: 0, right: minimumLineSpacing / 2)
    }
}

//
//  ImageContentView.swift
//  TilesAppTest
//
//

import UIKit

class ImageContentView: UIView {
    
    var scale: CGFloat = 1;
    var offset: CGPoint = CGPointZero
    var imageSize = CGSizeZero
    
    let TileSize = 256
        
    private var contentView: UIView? {
        return subviews.first
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func updateScale(scale: CGFloat) {
        self.scale = scale
        setNeedsDisplay()
    }
    
    func updateOffset(offset: CGPoint) {
        self.offset = offset
        setNeedsDisplay()
    }
    
    func updateOffsetAndScale(offset: CGPoint, scale: CGFloat) {
        self.scale = scale
        self.offset = offset
        setNeedsDisplay()
    }
        
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 16),
        .foregroundColor: UIColor.black
    ]
    
    func drawIndex(r: CGRect, x: Int, y: Int) {
        let textRect = CGRect(x: r.origin.x + 10, y: r.origin.y + 10, width: 100, height: 50)
        let text = "\(x), \(y)"
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        attributedString.draw(in: textRect)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // -------------
        context.setLineWidth(2)
                                 
        let horizontalTiles = Int(ceil(imageSize.width / CGFloat(TileSize)))
        let verticalTiles = Int(ceil(imageSize.height / CGFloat(TileSize)))
        
        for x in 0...horizontalTiles {
            for y in 0...verticalTiles {
                
                let scaledTileSize = CGFloat(TileSize) * scale;
                
                let r = CGRect( x: CGFloat(x) * scaledTileSize - offset.x,
                                y: CGFloat(y) * scaledTileSize - offset.y,
                                width: scaledTileSize,
                                height: scaledTileSize)
                                
                // r to pozycja i rozmiar tile z uwzględnieniem przesunięcia oraz aktualnej skali
                // rect to okno widoku.
                // r.intersect(rect) określa które z tili są widoczne w widoku okna (k†óre nie jest przeskalowane
                if r.intersects(rect) {
                                                                      
                    context.setStrokeColor(UIColor.red.cgColor)
                    context.setFillColor(UIColor.white.cgColor)
                    context.addRect(r)
                    context.strokePath()
                    
                    drawIndex(r: r, x: x, y: y)
                    
                }
            }
        }
        
        // -------------
    }
}

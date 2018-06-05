//
//  playingcardview.swift
//  palycards
//
//  Created by Arpit Singh on 13/02/18.
//  Copyright © 2018 Arpit Singh. All rights reserved.
//

import UIKit
@IBDesignable
class playingcardview: UIView {
    
    var rank = 9 { didSet{ setNeedsDisplay(); setNeedsLayout()}}
    var suit = "♣️" { didSet{ setNeedsDisplay(); setNeedsLayout()}}
public    var faceup = true { didSet{ setNeedsDisplay(); setNeedsLayout()}}
    var facecardsize = size.facecardimagecal {didSet{setNeedsDisplay()}}
@objc  public func adjustface(byhandling recog: UIPinchGestureRecognizer){
        switch recog.state {
        case .changed,.ended:
            facecardsize *= recog.scale
            recog.scale = 1.0
        default:
            break
        }
    }
    private func centered(_ string: String , fontsize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontsize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        return NSAttributedString(string : string, attributes : [.paragraphStyle : paragraph,.font : font])
    }
    private var connerstring : NSAttributedString{
        return centered(rankstring+"\n"+suit, fontsize: connerfontsize)
    
    }
    func createcornnerlable() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
private lazy var upperlabel = createcornnerlable()
private lazy var lowerlabel = createcornnerlable()
    private func configured(_ label : UILabel){
        label.attributedText = connerstring
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !faceup
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
        setNeedsDisplay()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        configured(upperlabel)
        upperlabel.frame.origin = bounds.origin.offset(dx: conneroffset, dy: conneroffset)
        configured(lowerlabel)
        lowerlabel.transform = CGAffineTransform.identity.translatedBy(x: lowerlabel.frame.size.width, y: lowerlabel.frame.size.height).rotated(by: CGFloat.pi)
        lowerlabel.frame.origin = CGPoint(x : bounds.maxX,y : bounds.maxY).offset(dx: -conneroffset, dy: -conneroffset).offset(dx: -lowerlabel.frame.size.width, dy: -lowerlabel.frame.size.height)
        
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let roundrect = UIBezierPath(roundedRect : bounds,cornerRadius : connerradius)
     
      roundrect.addClip()
        UIColor.white.setFill()
        roundrect.fill()
         if faceup   {
       if  let facecard = UIImage(named: rankstring){
          facecard.draw(in: bounds.zoom(by: facecardsize))
        }else
       {
        drawpips()
        }
         }else{
            if  let facecard = UIImage(named: "back"){
                facecard.draw(in: bounds.zoom(by: size.facecardimagecal))
            }
        }
       
    }
    private func drawpips()
    {
        let pipsperrowforrank =  [[0], [1], [1,1], [1,1,1], [2,2], [2,1,2], [2,2,2], [2,1,2,2], [2,2,2,2], [2,2,1,2,2], [2,2,2,2,2]]
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsperrowforrank.reduce(0) { max($1.count, $0)})
            let maxHorizontalPipCount = CGFloat(pipsperrowforrank.reduce(0) { max($1.max() ?? 0, $0)})
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centered(suit, fontsize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centered(suit, fontsize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centered(suit, fontsize: probablyOkayPipStringFontSize /
                    (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
            
        }
        if pipsperrowforrank.indices.contains(rank) {
            let pipsPerRow = pipsperrowforrank[rank]
            var pipRect = bounds.insetBy(dx: conneroffset, dy: conneroffset).insetBy(dx: connerstring.size().width, dy: connerstring.size().height / 2)
            let pipString = createPipString(thatFits : pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.lefthalf)
                    pipString.draw(in: pipRect.righthalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            
        }
    }
 }
}
extension playingcardview {
    private struct size {
        static let  conerfontsizecal : CGFloat = 0.085
         static let  connerRadiuscal : CGFloat = 0.06
        static let  conneroffsetcal : CGFloat = 0.33
        static let  facecardimagecal : CGFloat = 0.75
        
    }
    private var connerradius : CGFloat{
        return bounds.size.height*size.connerRadiuscal
    }
    private var conneroffset :CGFloat {
        return connerradius*size.conneroffsetcal
    }
    private var connerfontsize : CGFloat{
        return bounds.size.height*size.conerfontsizecal
    }
    private var rankstring :String{
        switch rank {
        case 1:
            return "A"
        case 2...10 :
            return String(rank)
        case 11 :
            return  "J"
        case 12: return "Q"
        case 13: return "K"
            
        default:
            return "?"
        }
    }
}
extension CGRect{
    var lefthalf : CGRect{
        return CGRect(x : midX,y : midY,width : width/2 ,height : height/2)
    }
    var righthalf:CGRect {
         return CGRect(x : midX,y : midY,width : width/2 ,height : height/2)
    }
    func inset(by size:CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size:CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale : CGFloat) -> CGRect {
        let newwidth = width*scale
        let newheight = height*scale
        return insetBy(dx: (width - newwidth)/2, dy: (height - newheight)/2)
    }
}
extension CGPoint{
    func offset(dx :CGFloat ,dy : CGFloat) -> CGPoint {
        return CGPoint(x :x+dx ,y :y+dy )
        }
}


// RGB value converter
fileprivate func V(_ f: CGFloat) -> CGFloat {
    return f / 255
}

fileprivate func C(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a:  CGFloat = 1.0) -> UIColor {
    return UIColor(red: V(r), green: V(g), blue: V(b), alpha: a)
}

// ORIGINAL COPYRIGHT NOTE / ORIGINATES FROM MJRFlexStyleComponents
//
//  StyledControlDirection.swift
//  MJRFlexStyleComponents
//
//  Created by Martin Rehder on 16.07.16.
/*
 * Copyright 2016-present Martin Jacob Rehder.
 * http://www.rehsco.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit

@objc public enum StyledControlDirection: Int {
    case horizontal
    case vertical
    
    /**
     The principal size is the axis of the direction. Width when the direction is horizontal and height when the direction is vertical.
     */
    func principalSize(size: CGSize) -> CGFloat {
        switch self {
        case .horizontal:
            return size.width
        case .vertical:
            return size.height
        }
    }

    /**
     The non-principal size is the perpendicular axis of the direction. Height when the direction is horizontal and width when the direction is vertical.
     */
    func nonPrincipalSize(size: CGSize) -> CGFloat {
        switch self {
        case .horizontal:
            return size.height
        case .vertical:
            return size.width
        }
    }
    
    /**
     The principal size of the direction is applied. Vertical direction will flip the width and the height in the size.
     */
    func getSize(size: CGSize) -> CGSize {
        switch self {
        case .horizontal:
            return size
        case .vertical:
            return CGSize(width: size.width, height: size.height)
        }
    }
    
    /**
     The principal position of the direction is applied. Vertical direction will flip the X and the Y in the point.
     */
    func getPosition(p: CGPoint) -> CGPoint {
        switch self {
        case .horizontal:
            return p
        case .vertical:
            return CGPoint(x: p.y, y: p.x)
        }
    }
}

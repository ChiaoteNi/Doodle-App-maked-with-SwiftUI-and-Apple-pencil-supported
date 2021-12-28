//
//  DoodleInteractor.swift
//  Doodles in SwiftUI
//
//  Created by 倪僑德 on 2021/12/27.
//  Copyright (c) 2021 iOS@Taipei in iPlayground 2020. All rights reserved.
//
//  This file was generated by iOS@Taipei's Clean Architecture Xcode Templates, which
//  is goaled to help you apply clean architecture to your iOS projects,

import Combine
import CoreGraphics

protocol DoodleBusinessLogic {
    func didTapped(_ doodle: DrawDoodle)
    func didDragged(_ doodle: DrawDoodle, translation: CGSize)
    func didEndDragging(_ doodle: DrawDoodle, translation: CGSize)
    func didRotated(_ doodle: DrawDoodle, degrees: CGFloat)
    func didEndRotating(_ doodle: DrawDoodle, degrees: CGFloat)
    func didMagnificated(_ doodle: DrawDoodle, scale: CGFloat)
    func didEndMagnificating(_ doodle: DrawDoodle, scale: CGFloat)
}

final class DoodleInteractor: DoodleBusinessLogic {
    
    var stateStore: DoodleStateStoreLogic?
    let priorityWorker: DoodleManipulator
    
    private var lastOffset: CGPoint = .zero
    private var lastRotationDegree: CGFloat = .zero
    private var lastScale: CGFloat = 1
    
    init(
        stateStore: DoodleStateStoreLogic? = nil,
        priorityWorker: DoodleManipulator = DoodleManipulator()
    ) {
        self.stateStore = stateStore
        self.priorityWorker = priorityWorker
    }
    
    func didTapped(_ doodle: DrawDoodle) {
        priorityWorker.setFocus(doodle)
        stateStore?.update(doodle)
    }
    
    func didDragged(_ doodle: DrawDoodle, translation: CGSize) {
        priorityWorker.setFocus(doodle)
        
        let offset = makeOffset(by: translation)
        lastOffset += offset
        
        updateDoodle(doodle, offset: offset)
    }
    
    func didEndDragging(_ doodle: DrawDoodle, translation: CGSize) {
        let offset = makeOffset(by: translation)
        lastOffset = .zero
        updateDoodle(doodle, offset: offset)
    }
    
    func didRotated(_ doodle: DrawDoodle, degrees: CGFloat) {
        let degree = degrees - lastRotationDegree
        lastRotationDegree = degrees
        updateDoodle(doodle, degree: degree)
    }
    
    func didEndRotating(_ doodle: DrawDoodle, degrees: CGFloat) {
        let degree = degrees - lastRotationDegree
        lastRotationDegree = .zero
        updateDoodle(doodle, degree: degree)
    }
    
    func didMagnificated(_ doodle: DrawDoodle, scale: CGFloat) {
        let scale = lastScale * scale
        updateDoodle(doodle, scale: scale)
    }
    
    func didEndMagnificating(_ doodle: DrawDoodle, scale: CGFloat) {
        let scale = lastScale * scale
        lastScale = scale
        updateDoodle(doodle, scale: scale)
    }
}

// MARK: - Private functions
extension DoodleInteractor {
    
    private func makeOffset(by translation: CGSize) -> CGPoint {
        return CGPoint(
            x: translation.width,
            y: translation.height
        ) - lastOffset
    }
    
    private func updateDoodle(_ doodle: DrawDoodle, offset: CGPoint) {
        doodle.frame = CGRect(
            origin: doodle.frame.origin + offset,
            size: doodle.frame.size
        )
        stateStore?.update(doodle)
    }
    
    private func updateDoodle(_ doodle: DrawDoodle, degree: CGFloat) {
        doodle.rotationDegree += degree
        stateStore?.update(doodle)
    }
    
    private func updateDoodle(_ doodle: DrawDoodle, scale: CGFloat) {
        doodle.scale = scale
        stateStore?.update(doodle)
    }
}

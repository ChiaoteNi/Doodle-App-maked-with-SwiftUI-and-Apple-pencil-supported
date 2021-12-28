//
//  DoodlePadInteractor.swift
//  Doodle in SwiftUI
//
//  Created by 倪僑德 on 2021/12/25.
//  Copyright (c) 2021 iOS@Taipei in iPlayground 2020. All rights reserved.
//
//  This file was generated by iOS@Taipei's Clean Architecture Xcode Templates, which
//  is goaled to help you apply clean architecture to your iOS projects,

import Combine

protocol DoodlePadBusinessLogic {
    //...
}

protocol DoodlePadPresentationLogic {
    //...
}

final class DoodlePadInteractor: DoodlePadBusinessLogic {
    
    var presenter: DoodlePadPresentationLogic?
}
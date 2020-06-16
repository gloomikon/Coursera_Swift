//
//  main.swift
//  FirstCourseFinalTask
//
//  Copyright © 2017 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseFinalTaskChecker

let checker = Checker(usersStorageClass: UserStorageClass.self,
                      postsStorageClass: PostsStorageClass.self)

checker.run()


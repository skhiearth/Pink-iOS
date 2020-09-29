//
//  GailModel.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 24/09/20.
//

import Foundation

func gailModel(agemen: Int, agecat: Int, nbiops: Int, ageflb: Int, numrel: Int) -> Int{
    var first = 0.0
    var second = 0.0
    var third = 0.0

    if(agemen==0){
        first = 1
    } else if (agemen==1){
        first = 1.099
    } else if (agemen==2){
        first = 1.207
    }

    if (nbiops==0){
      second = 1
    } else if (nbiops==1){
      if (agecat==0) {
        second = 1.698
      } else if (agecat==1){
        second = 1.273
      }
    } else if (nbiops==2) {
      if (agecat==0) {
        second = 2.882
      } else if (agecat==1) {
        second = 1.620
      }
    }

    if (ageflb==0){
      if (numrel==0){
        third = 1
      } else if (numrel==1){
        third = 2.607
      } else if (numrel==2){
        third = 6.798
      }
    } else if (ageflb==1) {
      if (numrel==0){
        third=1.244
      }else if (numrel==1){
        third=2.681
      } else if (numrel==2){
        third=5.775
      }
    } else if (ageflb==2) {
      if (numrel==0){
        third=1.548
      } else if (numrel==1){
        third=2.756
      } else if (numrel==2){
        third=4.907
      }
    } else if (ageflb==3){
      if (numrel==0){
        third=1.927
      } else if (numrel==1){
        third=2.834
      } else if (numrel==2){
        third=4.169
      }
    }

    let relrisk = ((first*second*third)*100)*0.01

    return Int(relrisk)
}

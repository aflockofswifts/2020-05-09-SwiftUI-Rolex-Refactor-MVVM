//
//  TestTimeCalc.swift
//  SwiftUI Rolex
//
//  Created by John James Retina on 5/7/20.
//  Copyright © 2020 John James. All rights reserved.
//

import SwiftUI

struct TestTimeCalc: View {
    var body: some View {
      VStack{
        Text("Hour Angle \(hourAngle(hrs: 6, mins: 0, secs: 0)) ")
        Text("Hour Angle \(hourAngle(hrs: 6, mins: 30, secs: 0)) ")
        Text("Hour Angle \(hourAngle(hrs: 0, mins: 30, secs: 0)) ")
        Text("Hour Angle \(hourAngle(hrs: 7, mins: 0, secs: 0)) ")
      }.font(.largeTitle)
  }
}

struct TestTimeCalc_Previews: PreviewProvider {
    static var previews: some View {
        TestTimeCalc()
    }
}

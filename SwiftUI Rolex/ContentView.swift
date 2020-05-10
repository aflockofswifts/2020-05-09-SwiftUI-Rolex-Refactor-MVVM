//
//  ContentView.swift
//  SwiftUI Rolex
//
//  Created by John James Retina on 5/7/20.
//  Copyright © 2020 John James. All rights reserved.
//

import SwiftUI
import Combine

final class WatchModel: ObservableObject {
  @Published private (set) var dateDescription = ""
  @Published private (set) var hourAngle: Angle = .zero
  @Published private (set) var minutesAngle: Angle = .zero
  @Published private (set) var secondsAngle: Angle = .zero
  private var subscriptions = Set<AnyCancellable>()
  private var timer: Timer.TimerPublisher?
  init() {

    let formatter = DateComponentsFormatter()

    func hourAngle(hrs: Double, mins : Double, secs : Double) -> Angle {
      let hourDecimal = hrs + (mins / 60) + (secs / 3600)
      return .init(radians: hourDecimal / 12 * .pi * 2)
    }

    func minuteAngle(mins : Double, secs : Double) -> Angle {
      let minDecimal = mins + (secs / 60)
      return .init(radians: minDecimal / 60 * .pi * 2)
    }

    let timer = Timer.publish(every: 1, on: .main, in: .common)

    timer
      .prepend(Date())
      .map { date -> (Angle, Angle, Angle, String) in
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        let hour = components.hour.map(Double.init(_:)) ?? 0
        let minutes = components.minute.map(Double.init(_:)) ?? 0
        let seconds = components.second.map(Double.init(_:)) ?? 0
        return (
          hourAngle(hrs: hour, mins: minutes, secs: seconds),
          minuteAngle(mins: minutes, secs: seconds),
          Angle.radians(seconds / 60 * .pi * 2 ),
          formatter.string(from: components) ?? ""
        )
      }
      .sink(receiveValue: { [weak self] (hourAngle, minuteAngle, secondsAngle, dateDescription) in
          guard let self = self else { return }
          self.hourAngle = hourAngle
          self.minutesAngle = minuteAngle
          self.secondsAngle = secondsAngle
          self.dateDescription = dateDescription
       })
      .store(in: &subscriptions)

    self.timer = timer
  }

  func start() {
    timer?.connect().store(in: &subscriptions)
  }

}

struct ContentView: View {
  @ObservedObject private var model: WatchModel = .init()
  var body: some View {
    GeometryReader { geometry in
      VStack{
        Text(self.model.dateDescription)
        ZStack{
          Image("WatchBody")
            .resizable()
            .scaleEffect(1.6)
          Image("SubMarinerFace")
            .resizable()
          Image("HourHand")
            .resizable()
            .rotationEffect(self.model.hourAngle)
          Image("MinuteHand")
            .resizable()
            .rotationEffect(self.model.minutesAngle)
          Image("SecondHand")
            .resizable()
            .rotationEffect(self.model.secondsAngle)
        }
        .padding(50)
        .frame(width: min(geometry.size.width, geometry.size.height), height: min(geometry.size.width, geometry.size.height), alignment: .center)
      }
    }
    .onAppear() {
      self.model.start()
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

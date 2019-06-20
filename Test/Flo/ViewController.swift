/**
 * Copyright (c) 2017 Razeware LLC
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
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class ViewController: UIViewController {
  
  //Counter outlets
  @IBOutlet weak var counterView: CounterView!
  @IBOutlet weak var counterLabel: UILabel!
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var graphView: GraphView!
  
  //Label outlets
  @IBOutlet weak var averageWaterDrunk: UILabel!
  @IBOutlet weak var maxLabel: UILabel!
  @IBOutlet weak var stackView: UIStackView!
  
  var isGraphViewShowing = false
  
  @IBAction func pushButtonPressed(_ button: PushButton) {
    if button.isAddButton {
      counterView.counter += 1
    } else {
      if counterView.counter > 0 {
        counterView.counter -= 1
      }
    }
    counterLabel.text = String(counterView.counter)
    
    if isGraphViewShowing {
      counterViewTap(nil)
    }
  }
    
    @IBAction func animateButtonTapped(_ sender: Any) {
        graphView.newGradient()
        graphView.setNeedsDisplay()
    }
    
  
  @IBAction func counterViewTap(_ gesture:UITapGestureRecognizer?) {
    if (isGraphViewShowing) {
      //hide Graph
      UIView.transition(from: graphView,
                        to: counterView,
                        duration: 1.0,
                        options: [.transitionFlipFromLeft, .showHideTransitionViews],
                        completion:nil)
    } else {
      //show Graph
      setupGraphDisplay()
      UIView.transition(from: counterView,
                        to: graphView,
                        duration: 1.0,
                        options: [.transitionFlipFromRight, .showHideTransitionViews],
                        completion: nil)
    }
    isGraphViewShowing = !isGraphViewShowing
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    counterLabel.text = String(counterView.counter) 
  }
  
  func setupGraphDisplay() {
    
    let maxDayIndex = stackView.arrangedSubviews.count - 1
    
    //1 - replace last day with today's actual data
    graphView.graphPoints[graphView.graphPoints.count-1] = counterView.counter
    //2 - indicate that the graph needs to be redrawn
    graphView.setNeedsDisplay()
    maxLabel.text = "\(graphView.graphPoints.max()!)"
    
    //3 - calculate average from graphPoints
    let average = graphView.graphPoints.reduce(0, +) / graphView.graphPoints.count
    averageWaterDrunk.text = "\(average)"
    
    //4 - setup date formatter and calendar
    let today = Date()
    let calendar = Calendar.current
    
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EEEEE")
    
    //5 - set up the day name labels with correct day
    for i in (0...maxDayIndex) {
      if let date = calendar.date(byAdding: .day, value: -i, to: today),
        let label = stackView.arrangedSubviews[maxDayIndex - i] as? UILabel {
        label.text = formatter.string(from: date)
      }
    }
  }
  
}


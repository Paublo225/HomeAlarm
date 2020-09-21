//
//  HomeActions.swift
//  Runner
//
//  Created by  Paul on 28/04/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit
import Flutter
import HomeKit


@available(iOS 11.0, *)
class HomeData {
   
    
    var actions = [HMActionSet]()
    var homeManager = HMHomeManager()
    

    func getHomes(result: FlutterResult) {
        guard let primaryHome: HMHome = self.homeManager.primaryHome else {
            result("Нет данных")
            return
        }
        
        
        result("\(primaryHome.name)")
        
    }
    
    
    
func getActionList(result: FlutterResult) {
        let home = homeManager.primaryHome
       let listAct = (home?.actionSets) ?? Array<HMActionSet>()
        var actlist = [String]()
        var i: Int = 0
     
        
        guard listAct != nil else {
            result(FlutterError(code: MyFlutterErrorCode.unavailable,
                                message: "Actions info unavailable",
                                details: nil))
            return
        }
      
        
        for listAct in listAct{
            let f = listAct.actionSetType
            if( f == HMActionSetTypeUserDefined) {
            i+=1
            actlist.append(listAct.name)
            }
          
            
            
        }
    
        print(actlist)
        result(actlist)
        
    
    }
    


     weak var pendingTrigger:HMTimerTrigger?
          
      
    var currentTrigger = [HMTrigger]()
    var listMain = [Any]()
  
    func listOfTr(result: FlutterResult) {
        let home = homeManager.primaryHome
         var trlist = [String]()
        var mainlist = [String]()
    
        
        
        let eventTr = (home?.triggers) ?? Array<HMEventTrigger>()
        for eventTr in eventTr {
            mainlist = [eventTr.name]
        
        }
        print(mainlist)
      result(mainlist)
    }
    
    
    
    
    var nameTrigger = [String]()
    func getNameTrigger(result: FlutterResult) {
        
          let home = homeManager.primaryHome
        let listtr = (home?.triggers) ?? Array<HMEventTrigger>()
        
        guard listtr != nil else {
            result(FlutterError(code: MyFlutterErrorCode.unavailable,
                                message: "Actions info unavailable",
                                details: nil))
            return
        }
        for listtr in listtr {
            
            nameTrigger.append(listtr.name)
        }
        print(nameTrigger)
        result(nameTrigger)
        
    }
    
    func getTimeTrigger(result:FlutterResult) {
      let home = homeManager.primaryHome
      let listtr =   Array<HMEventTrigger>()
      var timeTrigger = [String]()
        
        for list in listtr {
            timeTrigger.append("\(list.events)")
        }
        print(timeTrigger)
        result(timeTrigger)
    }
    
   
    
    func createNewTrigger(name:String, weekdays:[Int], hour:Int, minute:Int, sceneName: String, boolShit: Bool) {
        
          let home = homeManager.primaryHome
         let listAct = (home?.actionSets) ?? Array<HMActionSet>()
        var dateComp = DateComponents()
        dateComp.hour = hour
        dateComp.minute = minute
         var weekD = [DateComponents]()
        for weekday in weekdays {
       var recurrence = DateComponents()
        recurrence.weekday = weekday
        weekD.append(recurrence)
        }
        let calendarEvent = HMCalendarEvent(fire: dateComp)
        
        let trigger = HMEventTrigger(name: name, events: [calendarEvent], end: nil, recurrences: weekD, predicate: nil)
      
     
       
        print(home?.name)
        for listAct in listAct{
           
        if(listAct.name == sceneName){
                
        home?.addTrigger(trigger) {
                   (error) -> Void in
            
            
        trigger.addActionSet(listAct) {
            error in
            guard error == nil else {
                return
             }
        trigger.enable(boolShit){
                      (error) -> Void in
        }
        }
        }
        }
        }
      
       
       
    }
    
   
    
    func isSwitch(isOn: Bool) {
        let home = homeManager.primaryHome
        let listtr = (home?.triggers) ?? Array<HMEventTrigger>()
        
        for listtr in listtr  {
            if(isOn){
                
            listtr.enable(!isOn) { (error) -> Void in}
            }
            else {
            listtr.enable(isOn) { (error) -> Void in}
            }
        }
        
    }
    
    func switchbitch(name:String) {
        let home = homeManager.primaryHome
        let listtr = (home?.triggers) ?? Array<HMEventTrigger>()
   
        for lisstr in listtr {
          
            if (name == lisstr.name) {
                if(lisstr.isEnabled) {
                
                    lisstr.enable(false){ (error) -> Void in}
                
            }
                else{ lisstr.enable(true){ (error) -> Void in}}
                
            }
            else {
                print("bitch")
                
            }
        }
        
    }
    
    func deleteTrigger(namus: String)
   {
        let home = homeManager.primaryHome
        let listtr = (home?.triggers) ?? Array<HMEventTrigger>()
        for listtr in listtr {
      
        
            if(namus == listtr.name) {
                home?.removeTrigger(listtr) {
                    (error) -> Void in
      }
                
            
                
            }
        }
        for nameTrig in nameTrigger {
            if( namus == nameTrig) {
                nameTrigger.remove(at: nameTrig.count)
            }
        }
   }
    
    func deleteAll()
   {
        let home = homeManager.primaryHome
        let listtr = (home?.triggers) ?? Array<HMEventTrigger>()
        for listtr in listtr {
        
                home?.removeTrigger(listtr) {
                    (error) -> Void in}
                
        }
   }
    
    
    func triggerlist(result:FlutterResult) {
     
        var triggerlistcomp = [String]()
        guard currentTrigger != nil else {
            result("No triggers")
            return
        }
        for currentTrigger in currentTrigger {
            print(currentTrigger)
            triggerlistcomp.append(currentTrigger.name)
            
        }
        result(triggerlistcomp)
    }
    
    
    
    
    
    
    
  
    func updateTriggers (result:FlutterResult) {
        
        var triggers = [HMTrigger]()
       if let currentHome = self.homeManager.primaryHome {
               triggers += currentHome.triggers as [HMTrigger]
           }
        for triggers in triggers {
            print(triggers.name)
        result(triggers.name)
        }
       }

    
    
    
 /* for actions in myHome.actionSets {
        if (actionSet.name == "Night") {
            timeTrigger.addActionSet(actionSet, completionHandler: { error in
                if error != nil {
                    if let error = error {
                        print("\(error)")
                    }
                } else {
                    print("Add Action Set to Trigger")
                }
            })
        }
    }


    
    */
   /* extension ActionSetsViewController: ActionSetActionHandler {
        func handleExecute(_ actionSet: HMActionSet) {
            switch store.actionSetStoreKind {
            case .home(let home):
                home.executeActionSet(actionSet) { [weak self] error in
                    if let error = error {
                        print("# error: \(error)")
                    }
                    self?.refresh()
                }
            case .trigger(let trigger):
                trigger.home?.executeActionSet(actionSet) { [weak self] error in
                    if let error = error {
                        print("# error: \(error)")
                    }
                    self?.refresh()
                }
            }
        }

        func handleRemove(_ actionSet: HMActionSet) {
            switch store.actionSetStoreKind {
            case .home(let home):
                home.removeActionSet(actionSet) { [weak self] error in
                    if let error = error {
                        print("# error: \(error)")
                    }
                    self?.refresh()
                }
            case .trigger(let trigger):
                trigger.removeActionSet(actionSet) { [weak self] error in
                    if let error = error {
                        print("# error: \(error)")
                    }
                    self?.refresh()
                }
            }
        }
    }

    // MARK: - ActionSetSelector
    extension ActionSetsViewController: ActionSetSelector {
        func selectActionSet(_ actionSet: HMActionSet) {
            switch store.actionSetStoreKind {
            case .trigger(let trigger):
                trigger.addActionSet(actionSet) { [weak self] error in
                    if let error = error {
                        print("# error: \(error)")
                    }
                    self?.refresh()
                }
            default:
                break
            }
        }
    }*/
    
    
  /*  @available(iOS 11.0, *)
    func createTrigger(result:FlutterResult){
        var dateComponents = DateComponents()
        dateComponents.hour = 17
        dateComponents.minute = 30
        let calendarEvent = HMCalendarEvent(fire: dateComponents)
        let eventTrigger = HMEventTrigger(name: "Every day at 5:30PM", events: [calendarEvent],predicate: nil)
        let sunriseEvent = HMSignificantTimeEvent(significantEvent: HMSignificantEvent.sunrise, offset: nil)
        var weekdays = [DateComponents]()
        for weekday in 2...5 {
        var recurrence = DateComponents()
        recurrence.weekday = weekday
        weekdays.append(recurrence)
        }
        let eventsTrigger = HMEventTrigger(name: "Sunrise, Daily",
        events: [sunriseEvent], end: nil,
        recurrences: weekdays, predicate: nil)
    }
    
    
    
    */
    
    
    
    
    
    
    
   /* func saveTrigger() {
    if let pendingTrigger = pendingTrigger {
        let triggerName = self.nameField.text!
        let calendar = NSCalendar.current
    let selectedDate = self.datePicker.date
    var recurrenceComp:NSDateComponents?
        if repeatSwitch.isOn || repeatDaily.isOn {
    recurrenceComp = NSDateComponents()
            if repeatSwitch.isOn {
    recurrenceComp?.minute = 5
    }
            if repeatDaily.isOn {
    recurrenceComp?.day = 1
    }
    }
        pendingTrigger.updateRecurrence(recurrenceComp as DateComponents?) {
    error in
    if error != nil {
    NSLog("Failed updating recurrence, error:\(error)")
    }
    }
    pendingTrigger.updateName(triggerName) {
    error in
    if error != nil {
    NSLog("Failed updating fire date, error:\(error)")
    }
    }
    
    }
    else {
        if let currentHome = self.homeManager.primaryHome{
            guard let triggerName = self.nameField.text else { return  }
        let calendar = NSCalendar.current
        let selectedDate = self.datePicker.date
            let dateComp = calendar.component(.hour, from: selectedDate)
    let fireDate = calendar.dateComponents([.minute, .hour], from: selectedDate)

    var recurrenceComp:NSDateComponents?
        if repeatSwitch.isOn || repeatDaily.isOn {
    recurrenceComp = NSDateComponents()
            if repeatSwitch.isOn {
    recurrenceComp?.minute = 5
    }
            if repeatDaily.isOn {
    recurrenceComp?.day = 1
    }
    }
            let trigger = HMTimerTrigger(name: triggerName ?? , fireDate: selectedDate, timeZone: nil, recurrence: recurrenceComp as DateComponents?, recurrenceCalendar: nil)
    
    }
    }
    }*/
    
    
    }
   



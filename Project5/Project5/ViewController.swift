//
//  ViewController.swift
//  Project5
//
//  Created by Vishalaxi Tandel on 4/25/16.
//  Copyright © 2016 Vishalaxi Tandel. All rights reserved.
//

import UIKit

public class MyDate {
    var mMonth: Int = 0
    var mDay: Int = 0
    var mYear:Int = 0
    
    // Class constructor
    init(month: Int, day: Int, year: Int) {
        mMonth=month
        mDay=day
        mYear=year
    }
    
    
    /*METHOD that checks if the range of the input date is valid*/
    public func mIsValidDate() -> Bool {
        var isValid=false;
        if mMonth >= 1 &&   mMonth <= 12 &&
            mDay  >= 1  &&  mDay<=31    &&
            mYear >= 1000  &&   mYear<=9999 {
                isValid=true;
        }
        
        if  isValid {
            //check the no of days in feb for leap year
            if  isLeapYear(mYear) {
                if mMonth == 2 && mDay > 29 {
                    isValid = false;
                }
            }
            else {
                if mMonth==2 && mDay>28 {
                    isValid=false;
                }
            }
        }
        return isValid;
        
    }
    /*METHOD that calculates the differences between two days in terms of dates*/
    public func mFindDiff(d2:MyDate) -> Int{
        
        var monthArray:[Int]
        // Array of days in every month with first element as zero to easily acces the array index as month integer
        monthArray = [0,31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        
        /* 1) Find the no of days within the two years*/
        var leapCount:Int=0,sumYearDays:Int=0;
        for var  yr=mYear+1;yr<d2.mYear;yr++ {
            if isLeapYear(yr) {
                leapCount+=1;
            }
            sumYearDays+=365;
        }
        sumYearDays+=leapCount
        
        /* 2) Find the no of days in the start date's year end*/
        var sumMonthAndDay:Int=0;
        for var month=mMonth + 1; month <= 12; month++ {
            
            sumMonthAndDay=sumMonthAndDay+monthArray[month];
        }
        
        sumMonthAndDay+=(monthArray[mMonth]-mDay); // add the day value
        if isLeapYear(mYear) && mMonth<=2 {
            sumMonthAndDay+=1;
        }
        
        /* 3) Find the no of days in the end date's year*/
        
        var sumMonthAndDay_part2:Int=0;
        for var month=1; month<d2.mMonth; month++ {
            sumMonthAndDay_part2+=monthArray[month];
        }
        sumMonthAndDay_part2+=d2.mDay; // add the day value
        if isLeapYear(d2.mYear) && d2.mMonth>2{
            sumMonthAndDay_part2+=1;
            
        }
        
        /* 4) To handle cases when month or year of both dates are same*/
        if mYear==d2.mYear{
            if mMonth==d2.mMonth {
                return d2.mDay-mDay;
            }else{
                var sum=0;
                for var i=mMonth+1;i<d2.mMonth;i++ {
                    sum+=monthArray[i];
                }
                let before=monthArray[mMonth]-mDay;
                let after=d2.mDay;
                if mMonth<2 && 2<mMonth{
                    return (before+sum+after+1);// leap year count
                }
                else{
                    return(before+sum+after);
                }
            }
        }
        
        return sumYearDays+sumMonthAndDay+sumMonthAndDay_part2;
    }
    
    /* METHOD that checks if the second date preceeds first date */
    public func mFirstPreceedesSecondDate(d2:MyDate) -> Bool{
        
        if(mYear>d2.mYear){
            return false
            
        }else{
            if(mYear==d2.mYear){
                if(mMonth>d2.mMonth){
                    return false
                }else{
                    if(mMonth==d2.mMonth){
                        if(mDay>d2.mDay){
                            return false
                        }
                    }
                }
            }
        }
        
        return true
    }

}//end of MyDate Class

/*Function that checks if a given year as a leap year*/
public func isLeapYear(year: Int) -> Bool {
    if(year%4 == 0){
        if( year%100 == 0) {  // Checking for a century year
            if ( year%400 == 0){
                return true;
            }
            else {
                return false;
            }
        }
        else {
            return true;
        }
    }
    else {
        return false;
    }
}


class ViewController: UIViewController {
    
    
    
    /*Six text fields to get the input date fields*/
    
    @IBOutlet weak var m1tf: UITextField!
    @IBOutlet weak var d1tf: UITextField!
    @IBOutlet weak var y1tf: UITextField!

    @IBOutlet weak var m2tf: UITextField!
    @IBOutlet weak var d2tf: UITextField!
    @IBOutlet weak var y2tf: UITextField!

    
    @IBAction func calculateButton(sender: AnyObject) {
        
        /*Get the values from the six text fields*/
        
        let month1:Int?=Int(m1tf.text!)
        let day1:Int?=Int(d1tf.text!)
        let year1:Int?=Int(y1tf.text!)
        let month2:Int?=Int(m2tf.text!)
        let day2:Int?=Int(d2tf.text!)
        let year2:Int?=Int(y2tf.text!)
        
        var emptyField1=true,emptyField2=true,emptyField3=true,emptyField4=true,emptyField5=true,emptyField6=true
        
        /*Check if any of the variables contain nil values*/
        if let _=month1 {
            emptyField1=false
        }
        if let _=day1 {
            emptyField2=false
        }
        if let _=year1 {
            emptyField3=false
        }
        if let _=month2 {
            emptyField4=false
        }
        if let _=day2 {
            emptyField5=false
        }
        if let _=year2 {
            emptyField6=false
        }
        
        
        /*Perform the computation only if all six fields are non-empty*/
        if emptyField1==false && emptyField2==false && emptyField3==false && emptyField4==false && emptyField5==false && emptyField6==false {
        	let date1 = MyDate(month:month1!,day:day1!,year:year1!)
            let date2 = MyDate(month:month2!,day:day2!,year:year2!)
            
            /*Check if the first date is smaller than the econd date*/
            if(date1.mFirstPreceedesSecondDate(date2) == true){
                  if date1.mIsValidDate() && date2.mIsValidDate(){
                    var x=date1.mFindDiff(date2)
                    resultlab.text="Difference between two days: " + String(x)+" days"
                    x=0
                }else{
                    resultlab.text="Invalid Date.Correct Format(mm/dd/yyyy)"
                }
            }
            else{
                if date1.mIsValidDate() && date2.mIsValidDate(){
                    resultlab.text="First date must preceed second"

                }else{
                    resultlab.text="Invalid Date.Correct Format(mm/dd/yyyy)"
                }
            }
        }else{
            resultlab.text="Fill all fields correctly(mm/dd/yyyy)"
        }
        
    }
    
    @IBOutlet weak var resultlab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


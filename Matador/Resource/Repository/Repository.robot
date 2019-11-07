*** Variables ***
${btnIDSSignin}    //button[@type='button']
${fieldUsername}    //input[@id='username']
${fieldPassword}    //input[@id='password']
${btnSubmit}      //button[@type='submit']
${btnLeft}        //button[@ngbtooltip='Previous Month']
${btnRight}       //span[@class='oi oi-chevron-right']
${btnDate}        xpath=(//div[@class='calendar-date-content']//span[@class='mat-subheading-1']//b)
${btnAddTask}     //div[@class='modal-footer']//button
${fieldTask}      //textarea[@placeholder='Task']
${listTypeOfTask}    //select[@formcontrolname='timesheetType']
${listDuration}    //select[@formcontrolname='duration']
${fieldProjectOfPOP}    //input[@placeholder='Please select project']
${btnSave}        xpath=(//div[@class='modal-footer']//button[@type='button'])[2]
${btnCalendar}    //i[@class='fa fa-calendar']
${btnHolidayDate}    //div[@class='d-flex flex-row flex-wrap justify-content-center timesheet-calendar']/timesheet-calendar-date[@class='d-flex align-items-center flex-wrap justify-content-center calendar-date holiday ng-star-inserted']
${btnOK}          //div[@class='modal-footer']/button
${btnTrash}       //span[@class='oi oi-trash']
${fieldTaskDescription}    //textarea[@name='description']
${listFeature}    //select[@formcontrolname='storyId']

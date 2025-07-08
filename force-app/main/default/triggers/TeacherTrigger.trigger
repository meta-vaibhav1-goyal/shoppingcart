trigger TeacherTrigger on SOBJECT (before insert, before update) {

    if(Trigger.isInsert) {
        if(Trigger.isBefore) {
            
        }
    } else if(Trigger.isUpdate) {
        if(Trigger.isBefore) {
            TeacherTriggerHandler.preventTeacherUpdate(Trigger.New, )
        }   

}
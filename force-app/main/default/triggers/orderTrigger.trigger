trigger orderTrigger on Order (after update){
    OrderHelper.AfterUpdate(Trigger.New, Trigger.Old);
}
trigger ContactTagTrigger on Contact_Tag__c (before insert,
  before update,
  before delete,
  after insert,
  after update,
  after delete) 
{
 Object_Triggers__c cs = Object_Triggers__c.getInstance();
 TriggerFactory.createAndExecuteHandler(ContactTagHandler.class);
    
}
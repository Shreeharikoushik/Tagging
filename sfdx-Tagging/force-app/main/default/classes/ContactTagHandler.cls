public without sharing class ContactTagHandler implements ITrigger{
    
    private Set<Id> contactTagId = new Set<Id>();
    private Set<Id> tagId = new Set<Id>();
    
    public ContactTagHandler(){
        
    }
    public void bulkBefore(){
        if (Trigger.isInsert || Trigger.isUpdate) {
            for (Contact_Tag__c con : (List<Contact_Tag__c>) Trigger.new) {
                
                if (con.Contact__c != null) contactTagId.add(con.Contact__c);
                if(con.Tag__c != null) tagId.add(con.Tag__c);
            }
            
            
            
        }
        
    }
    public void bulkAfter(){}
    
    
    public void beforeInsert(SObject so){
        Contact_Tag__c  newConTag = (Contact_Tag__c) so;
        
        updateName(newConTag);
        
      if(newConTag.Contact_Tag_Key__c == null && newConTag.Contact__c != null && newConTag.Tag__c != null ){
            newConTag.Contact_Tag_Key__c = newConTag.Contact__c +''+ newConTag.Tag__c;
        }
    }
    
    
    public void beforeUpdate(SObject oldSo, SObject so){}
    
    
    public void beforeDelete(SObject so){}
    
    
    public void beforeFinally(){}
    
    
    public void afterInsert(SObject so){ 
        
    }
    
    
    public void afterUpdate(SObject oldSo, SObject so){}
    
    
    public void afterDelete(SObject so){}
    
    
    public void andFinally(){}
    
    private Map<Id, Contact> contactNameMap {
        get {
            if (contactNameMap == null) {
                contactNameMap = new Map<Id, Contact>();
                
                if (!contactTagId.isEmpty()) {
                    for (Contact ct : [
                        SELECT Id, FirstName, LastName
                        FROM Contact
                        WHERE Id IN :contactTagId
                    ]) {
                        contactNameMap.put(ct.Id, ct);
                    }
                }
            }
            
            return contactNameMap;
        }
        
        set;
    }
    
    private Map<Id, Tag__c> tagMap {
        get {
            if (tagMap == null) {
                tagMap = new Map<Id, Tag__c>();
                
                if (!contactTagId.isEmpty()) {
                    for (Tag__c t : [
                        SELECT Id,Name
                        FROM Tag__c
                        WHERE Id IN :tagId
                    ]) {
                        tagMap.put(t.Id, t);
                    }
                }
            }
            
            return tagMap;
        }
        
        set;
    }
    
	//This method is to update the ContactTag__c.Name field on ContactTag Creation 
    private void updateName(Contact_Tag__c con) {
        
        String contactTagName = ((!contactNameMap.isEmpty() && (!String.isBlank(con.Contact__c) && contactNameMap.containsKey(con.Contact__c) && !String.isBlank(contactNameMap.get(con.Contact__c).FirstName))? contactNameMap.get(con.Contact__c).FirstName : '')
                +''
                +(!contactNameMap.isEmpty() && (!String.isBlank(con.Contact__c) && contactNameMap.containsKey(con.Contact__c) && !String.isBlank(contactNameMap.get(con.Contact__c).LastName)) ? contactNameMap.get(con.Contact__c).LastName : '')
                +' - '
                +(!tagMap.isEmpty() && (!String.isBlank(con.Tag__c) && tagMap.containsKey(con.Tag__c))? tagMap.get(con.Tag__c).Name: '')
                +' - '
                +datetime.now());
        
        if(con != null)
        {
            con.Name = contactTagName.length() >= 80 ? contactTagName.substring(0,80):contactTagName;
        }
        
    }
}
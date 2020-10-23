trigger OppTrigger on Opportunity (after insert, after update) {
    //Generate a list of projects for insert
    List<Project__c> projectsforinsert = new List<Project__c>();

    //For each opporutity that entered the trigger
    for(Opportunity o : Trigger.new) {
        //Check to see if the stage is closed won and it wasnt closed won before
        if(o.StageName == 'Closed Won' && Trigger.oldMap.get(o.Id).get('StageName') != 'Closed Won') {
            //Create the new project
            Project__c p = new Project__c();
            p.Name = o.Name + ' - Project';
            p.Account__c = o.AccountId;
            p.Opportunity__c = o.Id;
            p.Start_Date__c = o.Planned_Start_Date__c;
            p.End_Date__c = o.Planned_End_Date__c;
            p.Description__c = o.Project_Description__c;
            
            //Add the new project to the list so that we can insert later
            projectsforinsert.add(p);
        }
    }
    
    //Check to see if we have any projects to insert, i.e. our list size is greater than zero
    if(projectsforinsert.size() > 0) {
        insert projectsforinsert;
    }
}
public without sharing class TaskRayTemplateService {
/*
    Created By: Rob Craven
    Purpose: Utility service used to support TaskRay Templating
        
    r 1.0 [Rob] 11/23/2016 - Created. 
*/


	public static void createTemplate(Id parentId, Id templateId)
	{
		
		if(parentId == null){ Throw new ArgumentException('parentId is required'); }
		if(templateId == null){ Throw new ArgumentException('templateId is required'); }
   		
   		String projectType = Schema.SObjectType.TASKRAY__Project__c.getKeyPrefix();
    	String taskType = Schema.SObjectType.TASKRAY__Project_Task__c.getKeyPrefix();		

		//Query Template & Template Items
		List<TaskRay_Template__c> lstTemplates = new List<TaskRay_Template__c>();
		lstTemplates = [SELECT Id, Name, wasCreated__c,
							(SELECT Id, Name, RecordTypeId, AssignedTo__c, SortOrder__c, Start_Date__c, End_Date__c, List__c, Priority__c, Description__c 
							 FROM TaskRay_Template_Items__r ORDER BY SortOrder__c DESC) 
						FROM TaskRay_Template__c 
						WHERE Id =: templateId];
		if(lstTemplates.size() == 0){ Throw new ApplicationException('Template to clone was not found'); }	
		if(lstTemplates[0].TaskRay_Template_Items__r != null && lstTemplates[0].TaskRay_Template_Items__r.size() > 0)
		{ 
			if(String.valueOf(parentId).startsWith(projectType)){ createTaskRayTasklist(parentId, lstTemplates[0]); }
			else if(String.valueOf(parentId).startsWith(taskType)){ createTaskRayChecklist(parentId, lstTemplates[0]); }
			else { Throw new ApplicationException('The parentId is invalid.'); }			
		}		
	}


	private static void createTaskRayTasklist(Id parentId, TaskRay_Template__c template)
	{
		//Try cloning template
		Savepoint sp = Database.setSavepoint();
		try 
		{
			Id recordtypeId = Schema.SObjectType.TaskRay_Template_Item__c.getRecordTypeInfosByName().get('Task Item').getRecordTypeId();

			//Create Task Items
			List<TASKRAY__Project_Task__c> lstTaskItems = new List<TASKRAY__Project_Task__c>();
			for(Integer i = 0; i < template.TaskRay_Template_Items__r.size(); i++)
			{
				if(template.TaskRay_Template_Items__r[i].RecordTypeId == recordtypeId)
				{
					TASKRAY__Project_Task__c nTaskItem = new TASKRAY__Project_Task__c();
					nTaskItem.TASKRAY__Project__c = parentId;				
					nTaskItem.Name = template.TaskRay_Template_Items__r[i].Name;
					nTaskItem.TASKRAY__List__c = template.TaskRay_Template_Items__r[i].List__c;
					nTaskItem.TASKRAY__Priority__c = template.TaskRay_Template_Items__r[i].Priority__c;
					nTaskItem.TASKRAY__SortOrder__c = template.TaskRay_Template_Items__r[i].SortOrder__c;
					nTaskItem.TASKRAY__trStartDate__c = template.TaskRay_Template_Items__r[i].Start_Date__c;
					nTaskItem.TASKRAY__Deadline__c = template.TaskRay_Template_Items__r[i].End_Date__c;
					nTaskItem.TASKRAY__Description__c = template.TaskRay_Template_Items__r[i].Description__c;
					if(template.TaskRay_Template_Items__r[i].AssignedTo__c != null)
					{
						nTaskItem.OwnerId = template.TaskRay_Template_Items__r[i].AssignedTo__c;
					}
					else 
					{
						nTaskItem.OwnerId = UserInfo.getUserId();
					}
					lstTaskItems.add(nTaskItem);
				}
			}
			insert lstTaskItems;
		} 
		catch(Exception e) 
		{
			Database.rollback(sp);  
			Throw new ApplicationException(e);
		}	
	}


	private static void createTaskRayChecklist(Id parentId, TaskRay_Template__c template)
	{
		//Try cloning template
		Savepoint sp = Database.setSavepoint();
		try 
		{
			Id recordtypeId = Schema.SObjectType.TaskRay_Template_Item__c.getRecordTypeInfosByName().get('Checklist Item').getRecordTypeId();

			//Create Checklist Group
			TASKRAY__trChecklistGroup__c nChecklistGroup = new TASKRAY__trChecklistGroup__c();
			nChecklistGroup.TASKRAY__TaskForGroup__c = parentId;
			nChecklistGroup.TASKRAY__SortOrder__c = 0;
			nChecklistGroup.Name = template.Name;
			insert nChecklistGroup;

			//Create Checklist Items
			List<TASKRAY__trChecklistItem__c> lstChecklistItems = new List<TASKRAY__trChecklistItem__c>();
			for(Integer i = 0; i < template.TaskRay_Template_Items__r.size(); i++)
			{
				if(template.TaskRay_Template_Items__r[i].RecordTypeId == recordtypeId)
				{
					TASKRAY__trChecklistItem__c nChecklistItem = new TASKRAY__trChecklistItem__c();
					nChecklistItem.TASKRAY__Project_Task__c = parentId;
					nChecklistItem.TASKRAY__trChecklistGroup__c = nChecklistGroup.Id;
					nChecklistItem.TASKRAY__SortOrder__c = template.TaskRay_Template_Items__r[i].SortOrder__c;
					nChecklistItem.Name = template.TaskRay_Template_Items__r[i].Name;
					if(template.TaskRay_Template_Items__r[i].AssignedTo__c != null)
					{
						nChecklistItem.TASKRAY__trOwner__c = template.TaskRay_Template_Items__r[i].AssignedTo__c;
					}
					else 
					{
						nChecklistItem.TASKRAY__trOwner__c = UserInfo.getUserId();
					}
					lstChecklistItems.add(nChecklistItem);
				}
			}
			insert lstChecklistItems;
		} 
		catch(Exception e) 
		{
			Database.rollback(sp);  
			Throw new ApplicationException(e);
		}		
	}
}
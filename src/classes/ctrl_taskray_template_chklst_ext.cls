public with sharing class ctrl_taskray_template_chklst_ext {
/*
    Created By: Rob Craven
    Purpose: Chatter action used to create repeatable TaskRay Checklists for TaskRay Tasks
        
    r 1.0 [Rob] 11/23/2016 - Created.  
*/

	private final TASKRAY__Project_Task__c parent;
	public Boolean wasCreated {get;private set;}
	public Boolean hasError {get;private set;}
	public String lastError {get;private set;}
	public List<SelectOption> lstTemplateOptions {get;set;}
	public String selectedOption {get;set;}
	public Boolean hasTemplates {get;private set;}


	public ctrl_taskray_template_chklst_ext(ApexPages.StandardController controller) 
	{
		parent = (TASKRAY__Project_Task__c)controller.getRecord();
		lstTemplateOptions = new List<SelectOption>();
		lstTemplateOptions.add(new SelectOption('--None--', '--None--'));
		wasCreated = false;
		hasError = false;
		hasTemplates = false;

		Id recordtypeId = Schema.SObjectType.TaskRay_Template_Item__c.getRecordTypeInfosByName().get('Checklist Item').getRecordTypeId();
		
		//Query Checklist Templates and Items
		List<TaskRay_Template__c> lstQueryTemplates = new List<TaskRay_Template__c>();
		lstQueryTemplates = [SELECT Id, Name, wasCreated__c,
								(SELECT Id FROM TaskRay_Template_Items__r WHERE RecordTypeId =: recordtypeId ORDER BY SortOrder__c DESC) 
		 					FROM TaskRay_Template__c WHERE Active__c = true ORDER BY Name ASC];
		
		//Check to ensure we are listing Checklist type Templates
		for(TaskRay_Template__c t : lstQueryTemplates)
		{
			if(t.TaskRay_Template_Items__r != null && t.TaskRay_Template_Items__r.size() > 0)
			{
				lstTemplateOptions.add(new SelectOption(t.Id, t.Name));
				hasTemplates = true;
			}
		}
	}


	public void createChecklist()
	{
		if(selectedOption == '--None--')
		{ 
			wasCreated = false; 
		}
		else 
		{
			try 
			{
				TaskRayTemplateService.createTemplate(parent.Id, selectedOption); //templateId
				wasCreated = true;
			} 
			catch(Exception e) 
			{ 
				System.debug(e.getMessage());
				hasError = true;
				lastError = e.getMessage();
			}
		}
	}
}
public with sharing class ctrl_taskray_template_clone_ext {
/*
    Created By: Rob Craven
    Purpose: Custom button to clone a parent record with it's child records.  Allows us to set defaults, and nullify fields
        
    r 1.0 [Rob] 11/24/2016 - Created.  
*/

	private final ApexPages.StandardController con {get; private set;}
	private SObject parent {get;set;}
	public String returnURL {get;set;}
	public String cancelURL {get;set;}
	public Boolean pageHasErrors {get;set;}


	public ctrl_taskray_template_clone_ext(ApexPages.StandardController controller) 
	{
		this.con = controller;
		this.parent = controller.getRecord();
		this.returnURL = ApexPages.currentPage().getParameters().get('retURL');
		this.cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
	}


	public PageReference cloneWithChildren()
	{
		Savepoint sp = Database.setSavepoint();
		TaskRay_Template__c clonedTemplate;

		try 
		{
			//Copy the parent record, Template, only include the fields we want to clone and provide default values where necessary
			TaskRay_Template__c templateToClone = [SELECT Id, Name FROM TaskRay_Template__c WHERE Id =: parent.Id];
			clonedTemplate = templateToClone.clone(false);
			clonedTemplate.OwnerId = UserInfo.getUserId();
			insert clonedTemplate;

			//Copy the child records, Template Items, query only include the fields you want to copy
			List<TaskRay_Template_Item__c> lstTemplateItems = new List<TaskRay_Template_Item__c>();
			for(TaskRay_Template_Item__c item : [SELECT Id, Name, RecordTypeId, AssignedTo__c, SortOrder__c, Start_Date__c, End_Date__c, List__c, Priority__c, Description__c 
												  FROM TaskRay_Template_Item__c 
												  WHERE TaskRay_Template__c =: parent.Id ORDER BY SortOrder__c DESC])
			{
				TaskRay_Template_Item__c nTemplateItem = item.clone(false);
				nTemplateItem.TaskRay_Template__c = clonedTemplate.Id;  //reparent
				lstTemplateItems.add(nTemplateItem);
			}
			insert lstTemplateItems;
		} 
		catch(Exception ex) 
		{
			Database.rollback(sp);
			System.debug(ex.getMessage());			
			ApexPages.addMessages(ex);
			pageHasErrors = true;
			return null;
		}

		return new PageReference('/' + clonedTemplate.Id + '/e?cancelURL=' + cancelURL + '&retURL=%2F' + clonedTemplate.Id);		
	}
}
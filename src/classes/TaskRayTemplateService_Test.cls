@isTest
private class TaskRayTemplateService_Test{
	//Rob - 12/11/2016 - Code Coverage - 85%

	private static TASKRAY__Project__c nProject;
	private static TASKRAY__Project_Task__c nTask;
	private static TaskRay_Template__c nTemplate;


	private static void setupTaskTemplate()
	{
		nProject = new TASKRAY__Project__c();
		nProject.Name = 'TaskRay Templates';
		insert nProject;

		nTemplate = new TaskRay_Template__c();
		nTemplate.Name = 'TaskRay Test Task Template';
		nTemplate.Active__c = true;
		insert nTemplate;

		Id recordtypeId = Schema.SObjectType.TaskRay_Template_Item__c.getRecordTypeInfosByName().get('Task Item').getRecordTypeId();

		TaskRay_Template_Item__c nItem1 = new TaskRay_Template_Item__c();
		nItem1.TaskRay_Template__c = nTemplate.Id;
		nItem1.RecordTypeId = recordtypeId;
		nItem1.Name = 'Product Notification';
		nItem1.AssignedTo__c = UserInfo.getUserId();
		nItem1.SortOrder__c = 0;
		nItem1.Priority__c = 'Normal';
		nItem1.List__c = 'Holding';

		TaskRay_Template_Item__c nItem2 = new TaskRay_Template_Item__c();
		nItem2.TaskRay_Template__c = nTemplate.Id;
		nItem1.RecordTypeId = recordtypeId;
		nItem2.Name = 'Product Listing';
		nItem2.AssignedTo__c = UserInfo.getUserId();
		nItem2.SortOrder__c = 1;
		nItem2.Priority__c = 'Normal';
		nItem2.List__c = 'Holding';
		insert new List<SObject>{nItem1, nItem2};
	}


	private static void setupChecklistTemplate()
	{
		nProject = new TASKRAY__Project__c();
		nProject.Name = 'TaskRay Templates';
		insert nProject;

		nTask = new TASKRAY__Project_Task__c();
		nTask.Name = 'Ability to create instances of TaskRay checklists';
		nTask.TASKRAY__Project__c = nProject.Id;
		nTask.TASKRAY__List__c = 'Holding';
		nTask.TASKRAY__Priority__c = 'Normal';
		nTask.TASKRAY__SortOrder__c = 0;
		nTask.OwnerId = UserInfo.getUserId();
		insert nTask;

		nTemplate = new TaskRay_Template__c();
		nTemplate.Name = 'TaskRay Test Checklist Template';
		nTemplate.Active__c = true;
		insert nTemplate;

		Id recordtypeId = Schema.SObjectType.TaskRay_Template_Item__c.getRecordTypeInfosByName().get('Checklist Item').getRecordTypeId();

		TaskRay_Template_Item__c nItem1 = new TaskRay_Template_Item__c();
		nItem1.TaskRay_Template__c = nTemplate.Id;
		nItem1.RecordTypeId = recordtypeId;
		nItem1.Name = 'Research & Solution Architecture';
		nItem1.AssignedTo__c = UserInfo.getUserId();
		nItem1.SortOrder__c = 0;
		insert nItem1;
	}


	static testMethod void itShouldCreateTaskTemplate()
	{
		// Given a parent TaskRay Project, and Task Template
		setupTaskTemplate();

		Test.startTest();

		// When cereate template is called
		TaskRayTemplateService.createTemplate(nProject.Id, nTemplate.Id);


		// Then it should create instance of template
		List<TASKRAY__Project_Task__c> lstTasks = new List<TASKRAY__Project_Task__c>();
		lstTasks = [SELECT Id FROM TASKRAY__Project_Task__c WHERE TASKRAY__Project__c =: nProject.Id];
		System.assertEquals(2, lstTasks.size());

		Test.stopTest();
	}


	static testMethod void itShouldCreateChecklistTemplate()
	{
		// Given a parent TaskRay Project, and Task Template
		setupChecklistTemplate();

		Test.startTest();

		// When cereate template is called
		TaskRayTemplateService.createTemplate(nTask.Id, nTemplate.Id);


		// Then it should create instance of template
		List<TASKRAY__trChecklistItem__c> lstChecklistItems = new List<TASKRAY__trChecklistItem__c>();
		lstChecklistItems = [SELECT Id FROM TASKRAY__trChecklistItem__c WHERE TASKRAY__Project_Task__c =: nTask.Id];
		System.assertEquals(1, lstChecklistItems.size());

		Test.stopTest();
	}
}
@isTest
private class ctrl_taskray_template_chklst_ext_test{
	//Rob - 12/10/2016 - Code Coverage - 87%

	private static TASKRAY__Project__c nProject;
	private static TASKRAY__Project_Task__c nTask;
	private static TaskRay_Template__c nTemplate;


	private static void setup()
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


	static testMethod void itShouldIgnoreNoneOption()
	{
		// Given a parent TaskRay Project, TaskRay Task, and Template
		setup();

		Test.startTest();

		// When chatter action button/page is invoked
		PageReference pr = Page.taskray_template_chklist_action;
		Test.setCurrentPage(pr);

		ApexPages.StandardController con = new ApexPages.StandardController(nTask);
		ctrl_taskray_template_chklst_ext ext = new ctrl_taskray_template_chklst_ext(con);

		// And create template action is called with no option selected
		ext.selectedOption = '--None--';
		ext.createChecklist();


		// Then it should not create/clone any templates
		List<TASKRAY__trChecklistItem__c> lstChecklistItems = new List<TASKRAY__trChecklistItem__c>();
		lstChecklistItems = [SELECT Id FROM TASKRAY__trChecklistItem__c WHERE TASKRAY__Project_Task__c =: nTask.Id];
		System.assertEquals(0, lstChecklistItems.size());

		Test.stopTest();
	}


	static testMethod void itShouldCreateInstanceOfTemplate()
	{
		// Given a parent TaskRay Project, and Task Template
		setup();

		Test.startTest();

		// When chatter action button/page is invoked
		PageReference pr = Page.taskray_template_chklist_action;
		Test.setCurrentPage(pr);

		ApexPages.StandardController con = new ApexPages.StandardController(nTask);
		ctrl_taskray_template_chklst_ext ext = new ctrl_taskray_template_chklst_ext(con);

		// And create template action is called with selected template
		ext.selectedOption = nTemplate.Id;
		ext.createChecklist();


		// Then it should create instance of template
		List<TASKRAY__trChecklistItem__c> lstChecklistItems = new List<TASKRAY__trChecklistItem__c>();
		lstChecklistItems = [SELECT Id FROM TASKRAY__trChecklistItem__c WHERE TASKRAY__Project_Task__c =: nTask.Id];
		System.assertEquals(1, lstChecklistItems.size());

		Test.stopTest();
	}
}
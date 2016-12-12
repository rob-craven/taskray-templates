@isTest
private class ctrl_taskray_template_tasklst_ext_test{
	//Rob - 12/10/2016 - Code Coverage - 87%

	private static TASKRAY__Project__c nProject;
	private static TaskRay_Template__c nTemplate;


	private static void setup()
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


	static testMethod void itShouldIgnoreNoneOption()
	{
		// Given a parent TaskRay Project
		setup();

		Test.startTest();

		// When chatter action button/page is invoked
		PageReference pr = Page.taskray_template_tasklst_action;
		Test.setCurrentPage(pr);

		ApexPages.StandardController con = new ApexPages.StandardController(nProject);
		ctrl_taskray_template_tasklst_ext ext = new ctrl_taskray_template_tasklst_ext(con);

		// And create template action is called with no option selected
		ext.selectedOption = '--None--';
		ext.createTasklist();


		// Then it should not create/clone any templates
		List<TASKRAY__Project_Task__c> lstTasks = new List<TASKRAY__Project_Task__c>();
		lstTasks = [SELECT Id FROM TASKRAY__Project_Task__c WHERE TASKRAY__Project__c =: nProject.Id];
		System.assertEquals(0, lstTasks.size());

		Test.stopTest();
	}


	static testMethod void itShouldCreateInstanceOfTemplate()
	{
		// Given a parent TaskRay Project, and Task Template
		setup();

		Test.startTest();

		// When chatter action button/page is invoked
		PageReference pr = Page.taskray_template_tasklst_action;
		Test.setCurrentPage(pr);

		ApexPages.StandardController con = new ApexPages.StandardController(nProject);
		ctrl_taskray_template_tasklst_ext ext = new ctrl_taskray_template_tasklst_ext(con);

		// And create template action is called with selected template
		ext.selectedOption = nTemplate.Id;
		ext.createTasklist();


		// Then it should create instance of template
		List<TASKRAY__Project_Task__c> lstTasks = new List<TASKRAY__Project_Task__c>();
		lstTasks = [SELECT Id FROM TASKRAY__Project_Task__c WHERE TASKRAY__Project__c =: nProject.Id];
		System.assertEquals(2, lstTasks.size());

		Test.stopTest();
	}
}
@isTest
private class ctrl_taskray_template_clone_ext_test{
	//Rob - 12/10/2016 - Code Coverage - 78%


	private static TaskRay_Template__c nTemplate;


	private static void setup()
	{
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


	static testMethod void itShouldCloneTemplate()
	{
		// Given a Template
		setup();


		// When clone controller is invoked
		ApexPages.StandardController con = new ApexPages.StandardController(nTemplate);
		ctrl_taskray_template_clone_ext ext = new ctrl_taskray_template_clone_ext(con);

		// And clone action is called
		PageReference pr = ext.cloneWithChildren();

		// Then it should clone template
		System.assert(pr != null);
		List<TaskRay_Template__c> lstTemplates = new List<TaskRay_Template__c>();
		lstTemplates = [SELECT Id FROM TaskRay_Template__c];
		System.assertEquals(2, lstTemplates.size());
	}
}
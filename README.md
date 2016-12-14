TaskRay Templates
====================================
 
<a href="https://githubsfdeploy.herokuapp.com?owner=rob-craven&repo=taskray-templates">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

[TaskRay](http://taskray.com) extension that allows Salesforce users to create templates of tasks and checklist items that can then be cloned using chatter publisher actions.  100% native Salesforce.com Look and Feel. 

##Template Screenshot
Ability to create template lists of tasks or checklist items.  Custom clone button used to clone both the parent template and child template items.

<img alt="Template Screenshot" src="https://raw.githubusercontent.com/rob-craven/taskray-templates/master/resources/img/taskray_template_checklist.png">

##Task Publisher Action Screenshot
Ability to clone any *task* template for any given *project*. 

<img alt="Task Publisher Action" src="https://raw.githubusercontent.com/rob-craven/taskray-templates/master/resources/img/task_publisher_action.png">

##Checklist Publisher Action Screenshot
Ability to clone any *checklist* template for any given *task*.  Note, Green checkmark indicates template was successfully cloned.

<img alt="Checklist Publisher Action" src="https://raw.githubusercontent.com/rob-craven/taskray-templates/master/resources/img/checklist_publisher_action.png">

##Features:
* Native Salesforce
* Create template lists of TaskRay tasks or checklists
* Custom template clone button used to clone both the parent template and child template items
* Task publisher action
* Checklist publisher action
* Publisher actions use Select2 drop-down for type-ahead feature

## Configuration
* Update *Profile -> Objects -> Select TaskRay Templates*
  * Set tab settings as *default on*
  * Set all fields as editable

* Update *Profile -> Objects -> Select TaskRay Template Items*
  * Set all fields as editable
  * Ensure both {Task, Checklist} record types are assigned, and then select one as a default record type

* Update *Setup -> Create -> Objects -> TaskRay Template Items -> Under the Record Type Section:*
  * Update page layout assignments so that *task item* record type utilizes the *task layout*, and the *checklist item* record type utilizes the *checklist item layout*

* Add publisher action buttons to *TaskRay Project* object:
  * *Setup -> Create -> Objects -> Select TaskRay Project*
  * Under section *Buttons, Links, and Actions* - click "new action"
  * Setup action as follows:
    <img alt="task action setup" src="https://raw.githubusercontent.com/rob-craven/taskray-templates/master/resources/img/add_task_action_button.png">
  * Update page layout, add new *Templates* action button to quick action menu
    <img alt="quick action config" src="https://raw.githubusercontent.com/rob-craven/taskray-templates/master/resources/img/page_layout_quick_actions_config.png">

* Add publisher action buttons to *TaskRay Task* object:
  * *Setup -> Create -> Objects -> Select TaskRay Task*
  * Under section *Buttons, Links, and Actions* - click "new action"
  * Setup action as follows:
    <img alt="task action setup" src="https://raw.githubusercontent.com/rob-craven/taskray-templates/master/resources/img/add_checklist_action_button.png">
  * Update page layout, add new *Templates* action button to quick action menu
    <img alt="quick action config" src="https://raw.githubusercontent.com/rob-craven/taskray-templates/master/resources/img/page_layout_quick_actions_config.png">

* Enable the TaskRay Templates tab for display

* Create sample Templates for yourself

##Implementation Notes
* Template item record types are not enforced.  A template when cloned will only contain the child items that are approriate for the given publisher action.  Ideally, it would be nice if Salesforce provided an option to allow administrators to default the child record type based on criteria of the parent record.

  * Please help vote up the following Salesforce idea, [Allow child record type to be based on parent](https://success.salesforce.com/ideaView?id=0873A000000CNNqQAO)

##Thrid-Party Code
This solution makes use of the following third-party components:
* [jQuery](https://jquery.com/)
* [Select2](https://select2.github.io/)
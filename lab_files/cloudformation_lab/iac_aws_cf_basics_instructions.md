![INE Logo](https://ine.com/_next/image?url=%2Fassets%2Flogos%2FINE-Logo-Orange-White-Revised.svg&w=256&q=75)

# Deploying AWS resources with AWS CloudFormation, console quick!

[TOC]

## Introduction

**Scenario:** The cybersecurity team demands complete control of creating users, groups, roles, and policies in AWS.  To that end, they want a standardized, repeatable method to accomplish this goal.  As a proof-of-concept (POC), we will use CloudFormation to create a solution that will create standardized users, groups, and policies in AWS.  Since we will design this to use the AWS Console, the cybersecurity team will quickly get up and running with the service and IaC.

The solution will be considered successful if anyone with access to CloudFormation can quickly run, monitor, and destroy users, groups, roles, and policies in AWS.  For the POC, our template must do the following:

1. The template must create a user and their associated access keys.

2. During the creation process Security can enter a temporary password for the user.

3. Two policies must be created allowing the following:

   **<u>Policy A:</u>**

   1. Describe CloudFormation resources
   2. List resources in CloudFormation
   3. Get information about resources in CloudFormation.

   **<u>Policy B:</u>**

   1. Full control of CloudFormation

4. Two groups are to be created, each with the policies designed above.

5. The new user must be associated with the two created groups.



## Steps

| Step | Instructions                                                 | Result                                                       |
| ---- | :----------------------------------------------------------- | ------------------------------------------------------------ |
| #1   | Login to AWS using the provided student name and password.   | Logged into the AWS Console                                  |
| #2   | In the service search bar type *CloudFormation* and click the CloudFormation service in the list | The AWS CloudFormation console is opened                     |
| #3   | Click the **Create Stack** button.  The create stack button will appear in the upper left or right-hand side of the page. | The Create Stack page is displayed                           |
| #4   | In the **Prerequisite - Create template** box, select the **Create template in Designer** radio button. | The radio button for creating the template in Designer is selected. |
| #5   | In the **Create template in Designer** box click the button labeled **Create template in Designer**. | The Designer page is loaded.                                 |
| #6   | In the Designer, at the bottom, click the **Template** tab and replace the contents of the window with the contents of the file [*aws_basics_cf_template.json*](https://github.com/Internetworkexpert/aws-iac-basics/blob/main/lab_files/cloudformation_lab/aws_basics_cf_template.json) . | The JSON appears in the template tab and resources appear on the work surface. |
| #7   | Click the **Create Stack** icon. Near the top of the window is a small icon that looks like a cloud with an arrow pointing up.  That is the **Create Stack** icon.  Click the **Create Stack** icon which will return you to the Create stack page.  (*Note: Notice that in the **Specify template** the **Amazon S3 URL** is selected and the **Amazon S3 URL** textbox is populated with an S3 bucket holding the template you created in the designer.*) | CloudFormation returns to the *Create stack* page.  The Amazon S3 URL textbox will be populated with the S3 key of the JSON template. |
| #8   | On the **Create stack** page click **Next** at the bottom of the page. | The **Specify stack details** page is displayed              |
| #9   | In the **Stack name** textbox enter `cf-security-demo`       | NA                                                           |
| #10  | In the **Parameters** section, in the **Password** textbox, enter a password.  Ensure the password has the following: (1) an upper case letter, (2) a lower case letter, (3) a number, (4) a special character, (5) is at least eight characters long.  *(Note: You do not need to remember/record this password.)* | NA                                                           |
| #11  | Click **Next**                                               | The **Configure stack options** page is displayed.           |
| #12  | In the **Tags** box, enter a key value of *purpose* with the value of *cf security demo*. | When the stack is deployed, all resources created will be tagged with *Purpose - cf security demo*. |
| #13  | Scroll to the bottom of the **Configure stack options** page and click **Next**. | The Review page is displayed.                                |
| #14  | On the **Review cf-security-demo** page, scroll to the bottom and click the acknowledgment box for creating IAM::Group resources. | NA                                                           |
| #15  | Click the **Create Stack** button at the bottom of the page  | You are returned to the CloudFormation page, where the output from the stack creation is shown. |
| #16  | As the stack creates, click the reload button (the button with a circularized arrow). | The page will reload, showing current progress.              |
| #17  | Continue reloading the page until you see an entry with the **Logical ID** of *cf-secuity-demo* and a **Status** of *Create_Complete*. |                                                              |

Let's take a moment and examine the output from the stack build here in the **Events** tab.

1. Scroll to the bottom of the page to the last (actually first) entry.  This will show that the cf-security-demo build started with a status reason of *User Initiated*.  This was the beginning of the stack build.
2. Scroll toward the top until you find the first entry with a status of **Create_Complete** (the text will be in green).  This indicates the first resources created by the stack.  In the **Logical ID** column, you can see the created resource.  It could be one of *CFNAdminGroup*, *CFNUserGroup*, or *CFNUser*.  
3. Continue scrolling back towards the top of the page, noting any lines with the status *Create_Complete* and the **Logical ID** of the resources created.  This is how you can tell what resources were created.
4. Note that, unless an error occurs, the name of your stack (in this case, *cf-security_demo*) appears at the top and bottom of the list.  
5. Switch to the **Resources** tab.  Here you can see all the resources created by your stack build.  

| Step | Instructions                                                 | Result                                                       |
| ---- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| #18  | In the **Resources** tab, find the entry with the **Logical ID** of *CFNUser*.  In the **Physical ID** column for that row, click the text starting with *cf-security-demo-CFNUser-*.  (Note: CloudFormation will add a string of letters and numbers after the text, which will be unique to your build.) | A new tab should open showing the **IAM Management Console**, **Summary** page. |
| #19  | On the **Permissions** tab of the Summary page, in the **Permissions policies** section, click the arrow to the left of *CFNAdmins*. | The policy statement for CFNAdmins is displayed.             |
| #20  | In the textbox that opens note the permissions (EAR: effect, action, & resource). | Note the values assigned to each of the elements.            |
| #21  | Switch back to the CloudFormation console and click the **Template** tab. | The template we used to create the stack is displayed.       |
| #22  | Scroll through the template and find the section labeled *CFNAdminPolicies*.  Note that the values you saw in the IAM Console for the CFNAdmins match the values indicated for the effect, action, and resource in the template. | The values in the IAM Console match what was in the template. |

> Feel free to continue comparing resources created in the CloudFormation and IAM console with what appears in the template.  For example, on the page you are now, you can compare the CFNUsers permissions to the entry in the template for CFNUserPolicies.

| Step | Instructions                                                 | Result                                               |
| ---- | ------------------------------------------------------------ | ---------------------------------------------------- |
| #23  | Back in the CloudFormation console, select the **Outputs** tab. | The Outputs tab is displayed.                        |
| #24  | In the **Outputs** box, note that **AccessKey** and **SecretKey** are displayed. | NA                                                   |
| #25  | Look again at the **Template** tab and scroll to the very bottom to the **Outputs** section. | You can see the **Outputs** section of the template. |

 Compare the the **Description** in the section to what you see in the **Description** column of the **Outputs** section.  This is where the values come from.

> What do you think about the fact that the values for the AccessKey and SecretKey are displayed here in the CloudFormation console?  More importantly, if this were an actual demo for the Security Team, how would you respond when asked about these displayed values?

Take a few more moments to review some of the other resources created before moving on.

**<u>Now we destroy everything!</u>**

| Step | Instructions                                                 | Result                                                       |
| ---- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| #26  | At the top of the cf-demo-app page, click the **Delete** button. | The **Delete cf-demo-app** box is displayed.                 |
| #27  | Click the **Delete stack** button                            | AWS CloudFormation initiates a deletion of the cf-demo-app stack. |
| #28  | Hit the refresh button until on the **Events** tab you see an entry with a logical id of *cf-demo-app* with a status of *DELETE_COMPLETE*. | The delete message for the delete event is shown on the Events tab. |

That's it!  You've just successfully deployed and destroyed the stack for IAM resources.

Close the lab to end your session if you are using INE's lab environment.  If you are using your own environment, all resources created by this lab will have been removed from your account.

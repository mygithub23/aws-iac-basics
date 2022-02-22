# Deploying AWS resources with AWS CloudFormation, console quick!

[TOC]



## Introduction

**Scenario:** The cybersecurity team is demanding complete control of the creation of users, groups, roles, and policies in AWS.  To that end, they want a standardizied, repeatable method to accomplish this goal.  As a proof-of-concept (POC), we will use CloudFormation to create a solution that will solve the problem of creating standardized users, groups, and policies in AWS.  Since we will design this to use the AWS Console, it will enable the cybersecurity team to quickly get up and running with the service and IaC.

The solution will be considered successful if anyone with access to CloudFormation can easily run, monitor, and destroy users, groups, roles, and policies in AWS.  For the POC, our template must do the following:

1. The template must create a user and their associated access keys.

2. During the creation process Security can enter a temporary password for the user.

3. Two policies must be created allowing the following:

   **<u>Policy A:</u>**

   1. Describe CloudFormation resources
   2. List resources in CloudFormation
   3. Get information about resources in CloudFormation

   **<u>Policy B:</u>**

   1. Full control of CloudFormation

4. Two groups are to be created, each with one of the policies created above.

5. The new user must be associated with the two created groups.



## Steps

- | Step | Instructions                                                 | Result                                                       |
  | ---- | :----------------------------------------------------------- | ------------------------------------------------------------ |
  | #1   | Log into AWS using the provided student name and password    | Logged into the AWS Console                                  |
  | #2   | In the service search bar type *CloudFormation* and click the CloudFormation service in the list | The AWS CloudFormation console is opened                     |
  | #3   | Click the **Create Stack** button.  The create stack button will appear in the upper left or right hand side of the page. | The Create Stack page is displayed                           |
  | #4   | In the **Prerequisite - Preate template** box select he radio button for **Create template in Designer**. | The radio button for create template in Designer is selected. |
  | #5   | In the **Create template in Designer** box click the button labeled **Create template in Designer**. | The Designer page is loaded.                                 |
  | #6   | In the Designer, at the bottom click the **Template** tab and replace the contents of the window with the contents of the file [*aws_basics_cf_template.json*](https://github.com/Internetworkexpert/aws-iac-basics/blob/main/lab_files/cloudformation_lab/aws_basics_cf_template.json) . | The JSON appears in the template tab and resources appear on the work surface. |
  | #7   | Click the **Create Stack** icon.  It is the small cloud with an arrow pointing up, just above the resource types list on the left side of the page. | CloudFormation returns to the *Create stack* page.  The Amazon S3 URL textbox will be populated with the S3 key of the JSON template. |
  | #8   | Click **Next** at the bottom of the page                     | The **Specify stack details** page is displayed              |
  | #9   | In the **Stack name** textbox enter `cf_security_demo`       | NA                                                           |
  | #10  | In the **Parameters** section, in the **Password** text boxfield enter a password.  Ensure the password has the following: (1) upper case letter, (2) a lower case letter, (3)a number, and (4) a special character. | NA                                                           |
  | #11  | Click **Next**                                               | NA                                                           |
  | #12  | In the **Tags** box enter a key value of *purpose* with value of *cf security demo*. | When the stack is deployed all resources created will be tagged with *Purpose - cf security demo*. |
  |      | Scroll to the bottom of the **Configure stack options** page and click **Next**. | The Review page is displayed.                                |
  |      | On the *Review cf_security_demo* page, scroll to the bottom and click the acknowledgment box for creating IAM::Group resources. | NA                                                           |
  |      | Click the **Create Stack** button at the bottom of the page  | You are returned to the CloudFormation page where the output from the stack creation is shown. |
  |      |                                                              |                                                              |






# JSON Template

`{`

  `"AWSTemplateFormatVersion" : "2010-09-09",`



  `"Description" : "Stack to create resources for security team.  Based on CloudFormation minimal permissions for groups. ",`



  `"Parameters" : {`

​    `"Password": {`

​      `"NoEcho": "true",`

​      `"Type": "String",`

​      `"Description" : "New account password",`

​      `"MinLength": "1",`

​      `"MaxLength": "41",`

​      `"ConstraintDescription" : "the password must be between 1 and 41 characters"`

​    `}`

  `},`



  `"Resources" : {`

​    `"CFNUser" : {`

​      `"Type" : "AWS::IAM::User",`

​      `"Properties" : {`

​        `"LoginProfile": {`

​          `"Password": { "Ref" : "Password" }`

​        `}`

​      `}`

​    `},`



​    `"CFNUserGroup" : {`

​      `"Type" : "AWS::IAM::Group"`

​    `},`



​    `"CFNAdminGroup" : {`

​      `"Type" : "AWS::IAM::Group"`

​    `},`



​    `"Users" : {`

​      `"Type" : "AWS::IAM::UserToGroupAddition",`

​      `"Properties" : {`

​        `"GroupName": { "Ref" : "CFNUserGroup" },`

​        `"Users" : [ { "Ref" : "CFNUser" } ]`

​      `}`

​    `},`



​    `"Admins" : {`

​      `"Type" : "AWS::IAM::UserToGroupAddition",`

​      `"Properties" : {`

​        `"GroupName": { "Ref" : "CFNAdminGroup" },`

​        `"Users" : [ { "Ref" : "CFNUser" } ]`

​      `}`

​    `},`



​    `"CFNUserPolicies" : {`

​      `"Type" : "AWS::IAM::Policy",`

​      `"Properties" : {`

​        `"PolicyName" : "CFNUsers",`

​        `"PolicyDocument" : {`

​          `"Statement": [{`

​            `"Effect"   : "Allow",`

​            `"Action"   : [`

​              `"cloudformation:Describe*",`

​              `"cloudformation:List*",`

​              `"cloudformation:Get*"`

​              `],`

​            `"Resource" : "*"`

​          `}]`

​        `},`

​        `"Groups" : [{ "Ref" : "CFNUserGroup" }]`

​      `}`

​    `},`



​    `"CFNAdminPolicies" : {`

​      `"Type" : "AWS::IAM::Policy",`

​      `"Properties" : {`

​        `"PolicyName" : "CFNAdmins",`

​        `"PolicyDocument" : {`

​          `"Statement": [{`

​            `"Effect"   : "Allow",`

​            `"Action"   : "cloudformation:*",`

​            `"Resource" : "*"`

​          `}]`

​        `},`

​        `"Groups" : [{ "Ref" : "CFNAdminGroup" }]`

​      `}`

​    `},`



​    `"CFNKeys" : {`

​      `"Type" : "AWS::IAM::AccessKey",`

​      `"Properties" : {`

​        `"UserName" : { "Ref": "CFNUser" }`

​      `}`

​    `}`

  `},`



  `"Outputs" : {`

​    `"AccessKey" : {`

​      `"Value" : { "Ref" : "CFNKeys" },`

​      `"Description" : "AWSAccessKeyId of new user"`

​    `},`

​    `"SecretKey" : {`

​      `"Value" : { "Fn::GetAtt" : ["CFNKeys", "SecretAccessKey"]},`

​      `"Description" : "AWSSecretKey of new user"`

​    `}`

  `}`

`}`


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

| Step | Instructions                                                 | Result                                                       |
| ---- | :----------------------------------------------------------- | ------------------------------------------------------------ |
| #1   | Log into AWS using the provided student name and password    | Logged into the AWS Console                                  |
| #2   | In the service search bar type *CloudFormation* and click the CloudFormation service in the list | The AWS CloudFormation console is opened                     |
| #3   | In the upper left side of the screen, click the *Create Stack* button. | The Create Stack page is displayed                           |
| #4   | At the bottom right of the Create Stack page, click the *View in Designer* button. |                                                              |
| #5   | In the Designer, at the bottom click the *template* tab and paste the contents of the file [*aws_basics_cf_template.json*](https://github.com/Internetworkexpert/aws-iac-basics/blob/main/lab_files/cloudformation_lab/aws_basics_cf_template.json) into the window. | The JSON appears in the template tab and resources appear on the work surface. |
| #6   | Click the *Create Stack* icon.  It is the small cloud with an arrow pointing up, just above the resource types list on the left side of the page. | CloudFormation returns to the *Create stack* page.  The Amazon S3 URL textbox will be populated with the S3 key of the JSON template. |
| #7   | Click *Next*                                                 | The *Specify stack details* page is displayed                |
| #8   | In the *Stack name* textbox enter `cf_security_demo`         | NA                                                           |
| #9   | In the password field enter a password.  Ensure the password has the following: an upper case letter, a lower case letter, a number, and a special character. | NA                                                           |
| #10  | Click *Next*                                                 | NA                                                           |
| #11  | Scroll to the bottom of the *Configure stack options* page and click Next. | The Review page is displayed.                                |
| #12  | On the *Review cf_security_demo* page, scroll to the bottom and click the acknowledgment box for creating IAM::Group resources. | NA                                                           |
| #13  | Click the *Create Stack* button at the bottom of the page    | You are returned to the CloudFormation page where the output from the stack creation is shown. |
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


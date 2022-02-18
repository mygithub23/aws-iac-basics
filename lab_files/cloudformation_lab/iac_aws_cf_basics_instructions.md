# Deploying AWS resources with AWS CloudFormation, quick from the console.

[TOC]



## Introduction

**Scenario:** The cybersecurity team is demanding complete control of the creation of users, groups, roles, and policies in AWS.  To that end, they want a standardizied, repeatable method to accomplish this goal.  As a test, they would like you to create something that will not only show how IaC can help the organizations, but also solve the problem of creating standardized users, groups, and policies in AWS.

One of the great things about AWS CloudFormation is that we can deploy resources from the the AWS Console and watch the creation process.  An an engineer, you can leverage this capability to allow other parts of an organizations to more easily deploy resources into AWS.

In this lab, we will explore and deploy a template.  We will determine if the template meets security's requirements.  Those requirements are:

1. The template must create a user and their associated access keys.

2. During the creation process Security can enter a temporary password for the user.

3. Two policies must be created allowing the following:

   <u>Policy A:</u>

   1. Describe CloudFormation information
   2. List stacks in CloudFormation
   3. Get information from CloudFormation

   <u>Policy B:</u>

   1. Full control of CloudFormation

4. Two groups are to be created, each with one of the policies created above.

5. The new user must be associated with the two created groups.






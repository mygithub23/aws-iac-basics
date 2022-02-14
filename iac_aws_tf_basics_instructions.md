# Deploying AWS resources with Terraform, from scratch!

## Introduction
Something broke in the cloud, and you need to fix it quickly!  And it's 3 AM! :weary: .  The workstation you use day-to-day for cloud engineering is not available.  Everything has gone wrong, and everyone is looking at you to resolve the problem.  

>  This lab is designed to be a "real world scenario".  Often in these situations, you are forced to deal with several other problems just so you can get back to resolving the original issue.  You must solve for getting the tools needed, getting credentials correct, resolving a problem with the template, and finally ensuring your work is stashed back to a repo.  Real issues are not easy!  Let's get some experience handling "the real".

This lab will build your skill and confidence in addressing such issues promptly and efficiently.  You will learn how to quickly set up a working environment with tooling, deploy cloud resources using infrastructure as code, make an update, and then store our updated work using git.  To do this, we will:
1.  **Connect to AWS CloudShell:** To get a shell quickly, we will leverage AWS CloudShell.
1.  **Install tools:** Install tools like Terraform and git into CloudShell.
2.  **AWS CLI permissions:** Configure the AWS CLI with the appropriate key and secret key.
3.  **Clone GitHub repo, deploy resources:** Pull an IaC template from GitHub and use it to deploy resources to AWS.
4.  **Update and deploy:** Update the template and deploy the update.
5.  **Commit and clean up:** Commit back to GitHub and clean up.

> It is no stretch of the imagination to complete the above steps in less than 10 minutes—a great, demonstratable skill for you as a builder :sunglasses:.

## Lab Steps
### Start Lab
***Instructions about starting the lab on the platform*
*Instructions about copying down the access key & secret access key***


### Setup your workstation
| Step     | Instructions | Result | 
| -------- | -------- | -------- | 
| #1       | Log into the AWS Console using the provided username & password | Log into the console| 
| #2       | In the service search, type *cloudshell*, and then in the list of services, select ***CloudShell***| The CloudShell console opens. |
| #3       | Click ***Close*** in the Welcome card.| NA |
| #4       | Ensure you are in the correct region in the top right of the AWS Console window.| NA |
| #5       | In the console run `aws configure` pasting in the values from the lab start page for the *AWS Access Key ID*, *AWS Secret Access Key* values.  Set the *Default region name* to `us-east-2` and leave the *Default output format* value blank.  | Running `aws s3 ls` run and shows S3 buckets in the account (if any).  No errors for permissions. |
| #6      | Run `terraform` and then `git` to verify neither is installed in your CloudShell session. |
| #7     | Install Terraform by running the following commands: <ul><li>`sudo yum install -y yum-utils` install the utilities for yum.</li>  <li>`sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo` too to add the Terraform repo to yum.</li><li>`sudo yum -y install terraform` to install Terraform.</li>|
| #8    | Verify your Terraform installation by running `terraform --version`.| The installed version of Terraform is displayed. |
| #9   | Install git by running the following command to install git:<ul><li>`sudo yum install git`</li></ul> | Git is installed |
| #10  | Verify your git installation by running `git --version`. | The installed version of git is displayed. |

<br/>
> Check In: <br/> So far, we have solved the problem of getting a working environment and loading the tools to get the job done.  Now we need to get  
   
### Clone the GitHub repo containing the Terraform template and make updates.
| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| #1    | In a browser naviagate to `https://OUR PUBLIC GITHUB FOR THIS LAB` | The GitHub repo for this lab is displayed.|
| #2    | Clone the repo by running the following in CloudShell: `git clone https://SOMETHINGorOther' | The repo is copied into a new folder in your CloudShell directory. |
| #3    | In CloudShell, run: <ul><li>`cd [THE DIR NAME]`</li><li>`cat main.tf`</li></ul> | The template is written to the screen. |

In the output of the file main.tf noticd that:
- The `required_providers` is set to 'hashicorp/aws'.
- In the `provider "aws"` the profile is default (the default profile in your ~/.aws/config)
    
### 





# Deploying AWS resources with Terraform, from scratch!

## Introduction
Something broke in the cloud, and you need to fix it quickly!  And it's 3 AM! :weary: .  The workstation you use day-to-day for cloud engineering is not available, everything is going wrong, and everyone is looking at you to resolve the problem.  

>  This lab is designed to be a "real-world scenario." Often in these situations, you are forced to deal with several other problems so that you can get back to resolving the original issue.  You must solve for getting the tools needed, getting credentials correct, fixing a problem with the deployed resources, and finally ensuring your work is stashed back to a repo.  Real issues are not easy!  Let's get some experience handling "the real."

This lab will build your basic skills and confidence using IaC and addressing chaotic situations promptly and efficiently.  You will learn how to set up a working environment with tooling quickly, deploy cloud resources using infrastructure as code, make an update, and then store our updated work using git.   To do this, we will:
1.  **Start Lab:** Launch the lab environment and get login credentials.
1.  **Set up your workstation:** To get a shell quickly, we will leverage AWS CloudShell.  Then we will install tools like Terraform and git into CloudShell.
2.  **AWS CLI permissions:** Configure the AWS CLI with the appropriate key and secret key.
3.  **Clone GitHub repo, deploy resources:** Pull an IaC template from GitHub and deploy resources to AWS.
3.  **Initialize, format, and validate the template:**
3.  **Plan and apply the template:**
4.  **Update and deploy:** Update the template and deploy the update.
5.  **Commit and clean up:** Commit back to GitHub and clean up.

----
----
### 1. Start Lab
***Instructions about starting the lab on the platform*
*Instructions about copying down the access key & secret access key***

---

---



### 2. Set up your workstation
| Step     | Instructions | Result |
| -------- | -------- | -------- |
| #1       | Login to the AWS Console using the provided student username & password | Logged into the AWS console |
| #2       | In the service search, type `cloudshell`, and then in the list of services, select ***CloudShell***.  You can also click the icon for CloudShell on the ribbon bar... ![cloudshell_icon](/Users/brooksseahorn/Documents/ine_working_area/aws-iac-basics/images/cloudshell_icon.png) | The CloudShell console opens. |
| #3       | Click ***Close*** in the Welcome card.| NA |
| #4       | Ensure you are in the correct region in the top right of the AWS Console window.  You should be in `us-east-1`. | The Region selector shows *N. Virginia*. |
| #5       | In the console run `aws configure` pasting in the values from the lab start page for the *AWS Access Key ID*, *AWS Secret Access Key* values.  Set the *Default region name* to `us-east-1` and leave the *Default output format* value blank.  Then run the following command to check permissions: | Running `aws s3 ls` shows S3 buckets in the account (if any).  No errors for permissions. |
| #6    | Run the following to install yum utilities: `sudo yum install -y yum-utils` |Yum's utilities are installed|
| #7 | Run the following to configure the Hashicorp repository to git: `sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo` |Hashicorp's repository is available in this CloudShell session.|
| #8 | Run the following to install Terraform: `sudo yum -y install terraform` |Terraform is now installed in CloudShell|
| #9   | Verify your Terraform installation by running `terraform --version`.| The installed version of Terraform is displayed. |
| #10 | Install git by running the following command to install git:`sudo yum install git` | Git is installed |
| #11 | Verify your git installation by running `git --version`. | The installed version of git is displayed. |



> ***Check In:***  You now have a workstation with the tooling needed to deploy infrastructure.   
---
---
### 3. AWS CLI permissions
We now need to create an access key/secret access key combination for ourselves.  This is needed in order to configure the AWS CLI.  
| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| #1    | Run the following: `aws iam create-access-key --user-name <<PROVIDED_STUDENT_NAME>>'   | JSON for the access key and secret access key are written to the screen.  |
| #2    | Run `aws configure`  | You are prompted to enter the AWS Access Key ID  for this user. |
| #3    | For the `AWS Access Key ID` enter the value `AccessKeyId` from the create key command above. | The value is pasted in and assigned. |
| #4    | In the prompt for `AWS Secret Access Key` enter the value from `SecretAccessKey` from the create key output.  Press Enter to continue. | The value is pasted in and assigned. |
| #5    | Enter `us-east-1` into the `Default region name` prompt.    | The value for Ohio is assigned to the default region in the AWS CLI.     |
| #6    | Press Enter to leave the `Default output format` field blank. | The aws configure command completes. |

---
---

### 4. Clone GitHub repo, deploy resources
| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| #1    | In a browser naviagate to `https://OUR PUBLIC GITHUB FOR THIS LAB` | The GitHub repo for this lab is displayed.|
| #2    | Clone the repo by running the following in CloudShell: `git clone https://SOMETHINGorOther' | The repo is copied into a new folder in your CloudShell directory. |
| #3    | In CloudShell, run: <ul><li>`cd [THE DIR NAME]`</li><li>`cat main.tf`</li></ul> | The template is written to the screen. |

> ### Reading the template file
> In the output of the file main.tf noticd that:
> - The `required_providers` is set to 'hashicorp/aws'.  This will pull in what we need to deploy resources to the AWS Cloud infrastructure.
>     - The `required_version` says that we want to use only provider versions greater than 0.14.9.  This can be a significant consideration should Hashicorp introduce a change that makes, say, version 0.14 different from a future version that introduces something "breaking changes."  In this case, we would set the value to a specific value such as `=0.14.9`, so we only use that version.
> - In the `provider "aws"` the profile is default (the default profile in your ~/.aws/config).  We also set the target region to US, Ohio (us-east-2).
>
> *Now things gets interesting* :thinking:
>
> - The `resource` section defines an EC2 instance running on a t3.micro instance with three tags.  Look at the Amazon Machine Image (AMI) value: `data.aws_ami.amazon_linux.id`.  That tells Terraform to look for a section named `aws_ami` in the file.  That section will query the AWS infrastructure to get the name of the latest Amazon Linux AMI.  This section guarantees that we always get the latest version of the Amazon Linux AMI.
>
> Now that we know what is going to happen, let's move on.
>

### 5. Initialize, format, and validate the template
| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| #1    | Run the command `terraform init` to initialize the directory with the needed providers.    | A message containing `Terraform has been successfully initialized!` will be printed to the screen. |
| #2    | Run the command `terraform fmt` to ensure the terraform template file is well formatted.     | The file name `main.tf` is written to the screen if no errors are found. |
| #3    | Run the command `terraform validate`    | The message `Success! The configuration is valid.` is written to the screen. |

### 6. Plan and Apply the template
| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| #1    | Run the command `terraform plan`    | A large amount of data will be written to the screen.  Verify that a value is shown for the ami that will be created.  At the end of the output you should see the following: `Plan: 1 to add, 0 to change, 0 to destroy.`|
| #2    | Run the command `terraform apply` to create the AWS resources. | Terraform prints out what it will deploy.|
| #3    | Enter `yes` to the question `Do you want to perform these actions?`    | Terraform will be creating the resources and eventually write the following to the screen: `Apply complete! Resources: 1 added, 0 changed, 0 destroyed.`    |


Now that the apply is complete, let's check to see if the resource was created by running the following, rather long query.  Ready?  Copy and paste the following command and run it.

`aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=Finance_Front_End" \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value}' \
    --output table`

When the command completes you should see a table with instance you created with the name Finance_Front_End.  

Awesome!  You've deployed your EC2 instance to the cloud. 

---
---

### 7. Update and deploy
> And another problem?!?!  After you deploy the server the Security Department says you must update the Name tag to Finance_Mobile_Front_End.  Ugh!

Now we are going to update the instance by changing the `Name` tag to `Finance_Mobile_Front_End`.  We will using vim to make the change.  Don't worry if you've never used vim before...I'll walk you through it. :wink:
| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| #1    | Run the following: `vim main.tf`    | The vim editor opens the file main.tf |
| #2    | Use the down arrow on your keyboard to the line in the file where `Name = "Finance_Front_End" is located    | The cursor is now on the Name key-value enter in the file. |
| #3    | Use your arrow key to put the cursor under the F in Front. | The cursor is now at the F in Front. |
| #4    | Hit your Esc key and then hit the i key.    | This puts vim into insert mode. |
| #5    | Type `Mobile_`    | The value for the Name tag will now be `Finance_Mobile_Front_End`. |
| #6    | Press the Esc key again and then type `:wq` to write to the file and quite vim. | You will be returned to the command prompt.    |
| #7    | Run `terraform plan`     | After a few moments, the plan will be written with one of the following lines saying the following: `Plan: 0 to add, 1 to change, 0 to destroy.`    |
| #8    | Run `terraform apply`    | Terraform begins the apply process. |
| #9    | At the prompt for `Enter a value:` enter yes.    | Terraform completes updating the running EC2 instance.    |

Now let's verify the update.  Run the following command:
`aws ec2 describe-tags --output table`

When the table prints to the screen scroll through the values and you should see a row in the Key column named `Name` with the value (the last column) of `Finance_Mobile_Front_End`.

### 8. Commit and clean up
You've successfully deployed and EC2 instance, make a change, and now that everyone is happy we need to stow our updates back to GitHub and clean everything up.  

| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| #1    | Run the command `terraform destory` | After a few moments the question `Do you really want to destroy all resources?` will be written and the prompt will be at `Enter a value:`. |
| #2    | Type yes to the prompt.    | Terraform terminates the instance.  This takes about a minute and will show the message `Destroy complete! Resources: 1 destroyed.` when completed.   |
| #3    | Type `git add .` (don't forget the perdion) and press Enter.  | git adds all files for pushing back to GitHub.    |
| #4    | Type `git commit -m "Updates tag for Name."` and then press Enter.    | A commit message is now associated with the change.    |
| #5    | Type `git push` and then Enter.    | The updated template is written back to GitHub.    |


TO DO: HOW TO UPDATE CLOUDSHELL WITH THE GITHUB ACCESS KEYS
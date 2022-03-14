![INE Logo](https://ine.com/_next/image?url=%2Fassets%2Flogos%2FINE-Logo-Orange-White-Revised.svg&w=256&q=75)

# Deploying AWS resources with Terraform, from scratch!

[TOC]

## Scenario / Introduction

Something broke in the cloud, and you need to fix it quickly!  And it's 3 AM! :weary: .  The workstation you use day-to-day for cloud engineering is not available, everything is going wrong, and everyone is looking at you to resolve the problem.  

>  This lab is designed to be a "real-world scenario." Often in these situations, you are forced to deal with several other problems so that you can get back to resolving the original issue.  You must solve for getting the tools needed, getting templates, fixing a problem with the deployed resources, and finally ensuring your work is stashed back to a repo.  Real issues are not easy!  Let's get some experience handling "the real."

This lab will build your basic skills and confidence using IaC and addressing chaotic situations promptly and efficiently.  You will learn how to set up a working environment with tooling quickly, deploy cloud resources using infrastructure as code, make an update, and then store our updated work using git.   To do this, we will:
1.  **Start Lab:** Launch the lab environment and get login credentials.
1.  **Set up your workstation:** To get a shell quickly, we will leverage AWS CloudShell.  Then we will install tools like Terraform and git into CloudShell.
3.  **Fork/Clone GitHub repo:** Pull an IaC template from GitHub and deploy resources to AWS.
3.  **Initialize, format, and validate the template:** Initialize and validate the template
3.  **Plan and apply the template:** Run plan to see what terraform will do, then apply the template.
4.  **Update and deploy:** Update the template and deploy the update.
5.  **Commit and clean up:** Commit back to GitHub and clean up.

----
----
### 1. Start Lab
***Instructions about starting the lab on the platform***

---

---



### 2. Set up your workstation
| Step     | Instructions | Result |
| -------- | -------- | -------- |
| #1       | Log in to the AWS Console using the provided student username & password | Logged into the AWS console |
| #2       | In the service search, type `cloudshell; in the list of services, select ***CloudShell***.  You can also click the icon for CloudShell on the ribbon bar. | The CloudShell console opens. |
| #3       | Click ***Close*** in the Welcome card.| NA |
| #4       | Ensure you are in the correct region in the top right of the AWS Console window.  You should be in `us-east-1`. | The Region selector shows *N. Virginia*. |
| #5       | In the console run `aws configure` pasting in the values from the lab start page for the *AWS Access Key ID*, *AWS Secret Access Key* values.  Set the *Default region name* to `us-east-1` and leave the *Default output format* value blank.  Then run the following command to check permissions: | Running `aws s3 ls` shows S3 buckets in the account (if any).  No errors for permissions. |
| #6    | Run the following to install yum utilities: `sudo yum install -y yum-utils` |Yum's utilities are installed|
| #7 | Run the following to configure the Hashicorp repository to git: `sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo` |Hashicorp's repository is available in this CloudShell session.|
| #8 | Run the following to install Terraform: `sudo yum -y install terraform` |Terraform is now installed in CloudShell|
| #9   | Verify your Terraform installation by running `terraform --version`.| The installed version of Terraform is displayed. |
| #10 | Install git by running the following command to install git:`sudo yum install git` | Git is installed |
| #11 | Verify your git installation by running `git --version`. | The installed version of git is displayed. |

> ***Check-In:***  You now have a workstation with the tooling needed to deploy infrastructure.   
---
---


### 3. Fork/Clone GitHub repo

| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| #1   | Log into your own GitHub account | NA |
| #2 | Navigate in browser to https://github.com/Internetworkexpert/cloud-aws-iac | NA |
| #3 | Fork the repo into your own account by click the **Fork** button in the top left of the web page.  If you have access to multiple accounts in GitHub, a dialog box will open asking where the repo should be forked to.  Choose your own account or the account of your choice. | GitHub will redirect back to your directory with the cloud-aws-iac forked into your account. |
| #4 | Back in your account, you will now have a forked copy of the *cloud-aws-iac* repo.  Click the **Code** button, and in the box that opens, copy the https string for cloning the repo (either select and copy or click the copy button to the right of the https URL). | The clone URL for your copy of the repo is copied. |
| #5 | Back in CloudShell run `git clone <PASTE THE URL COPIED IN THE ABOVE STEP>.` | Your copy of the repo is cloned into CloudShell. |
| #6 | Change into the new directory | NA |

Run `ls -la` to see the files you just forked.  For an explanation of the files, watch the accompying demo/walk through video for this lab.

---
---



### 4. Initialize, format, and validate the template

| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| #1    | Run the command `terraform init` to initialize the directory with the needed providers.    | A message containing `Terraform has been successfully initialized!` will be printed on the screen. |
| #2    | Run the command `terraform fmt` to ensure the terraform template file is well-formatted.     | The file name `main.tf` is written to the screen if no errors are found. |
| #3    | Run the command `terraform validate`    | The message `"Success! The configuration is valid."`is written to the screen. |

---

---



### 5. Plan and Apply the template

| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| #1    | Run the command `terraform plan`    | A large amount of data will be written on the screen.  Verify that a value is shown for the ami that will be created.  You should see the following at the end of the output: `Plan: 1 to add, 0 to change, 0 to destroy.` |
| #2    | Run the command `terraform apply` to create the AWS resources. | Terraform prints out what it will deploy.|
| #3    | Enter `yes` to the question `Do you want to perform these actions?`    | Terraform will be creating the resources and eventually write the following to the screen: `Apply complete! Resources: 1 added, 0 changed, 0 destroyed.`    |


Now that the apply is complete, let's see if the resource was created by running the following, rather long query.  Ready?  Copy and paste the following command and run it.

`aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=Finance_Front_End" \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value}' \
    --output table`

When the command completes, you should see a table with the instance you created with the name Finance_Front_End.  

Awesome!  You've deployed your EC2 instance to the cloud. 

---
---



### 6. Update and deploy

> And another problem?!?!  After you deploy the server, the Security Department says you must update the Name tag to Finance_Mobile_Front_End.  Ugh!

Now we will update the instance by changing the `Name` tag to `Finance_Mobile_Front_End`.  We will be using vim to make the change.  Don't worry if you've never used vim before...I'll walk you through it. :wink:
| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| #1    | Run the following: `vim main.tf`    | The vim editor opens the file main.tf |
| #2    | Use the down arrow on your keyboard to the line in the file where `Name = "Finance_Front_End" is located.   | The cursor is now on the Name key-value entered in the file. |
| #3    | Use your arrow key to put the cursor under the F in Front. | The cursor is now at the F in Front. |
| #4    | Hit your Esc key and then hit the i key.    | This puts vim into insert mode. |
| #5    | Type `Mobile_`    | The value for the Name tag will now be `Finance_Mobile_Front_End`. |
| #6    | Press the Esc key again and then type `:wq` to write to the file and quit vim. | You will be returned to the command prompt.    |
| #7    | Run `terraform plan`     | After a few moments, the plan will be written similar to the following: `Plan: 0 to add, 1 to change, 0 to destroy.` |
| #8    | Run `terraform apply`    | Terraform begins the apply process. |
| #9    | At the prompt for `Enter a value:` enter yes.    | Terraform completes updating the running EC2 instance.    |

Now let's verify the update.  Run the following command:
`aws ec2 describe-tags --output table`

When the table prints to the screen, scroll through the values, and you should see a row in the Key column named `Name` with the value (the last column) of `Finance_Mobile_Front_End`.

---

---



### 7. Commit and clean up

You've successfully deployed an EC2 instance, made a change, and now that everyone is happy, we need to stow our updates back to GitHub and clean everything up.  

BUT FIRST!!!...we have a little problem.  You will not be able to write back to your GitHub repo with a personal access token.  When you run `git push`, you will be prompted with a username and password.  The password is where you will enter the token.  The steps below include generating a token and adding to CloudShell.

| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| #1    | Run the command `terraform destroy`f | After a few moments, the question `Do you really want to destroy all resources?` will be written, and the prompt will be at `Enter a value:`. |
| #2    | Type yes to the prompt.    | Terraform terminates the instance.  This takes about a minute and will show the message `Destroy complete! Resources: 1 destroyed.` when completed.   |
| #3    | Type `git add .` (don't forget the period) and press Enter. | git adds all files for pushing back to GitHub.    |
| #4 | If not already logged in, log in to your GitHub account | You are logged into GitHub. |
| #5 | On the GitHub page, click the drop-down in the top right of the page next to your avatar's picture | A drop-down menu appears. |
| #6 | In the drop-down select *Settings*. | The Settings page appears. |
| #7 | Scroll to the bottom of the menu on the left side of the page and click *Developer settings* | The Developer Settings page appears. |
| #8 | On the left side of the page, in the menu, select *Personal access tokens* | The Personal access tokens page appears. |
| #9 | Click the **Generate new token** | You may be prompted to re-enter your GitHub password.  Enter your password, click enter and the *New personal access token* page will appear. |
| #10 | Enter a note to describe the purpose of this personal access token.  For example, *CloudFormation token* | NA |
| #11 | In the expiration drop-down, set the expiration to 30 days (the default at the time of this writing). | NA |
| #12 | For *Select scopes* select the top-level checkbox for *repo* | All of the checkboxes in the repo section are selected. |
| #13 | Scroll to the bottom of the page and click the **Generate token** button. | The page with the new token appears. |
| #14 | Copy the token (Ctrl-C).  Leave the page open until we are sure we have correctly copied and pasted the token into CloudShell | The page should be left open. |
|  |  |  |
| #   | Type `git commit -m "Updates tag for Name."` Then press Enter.    | A commit message is now associated with the change.    |
| #    | Type `git push` and then Enter.    | The updated template is written back to GitHub.    |
| # | Enter your GitHub username when prompted and press enter. | You are prompted for your GitHub password. |
| # | Paste in your GitHub personal access token you generated above and press enter. | The git command completes showing that updates have been pushed back to GitHub. |


TO DO: HOW TO UPDATE CLOUDSHELL WITH THE GITHUB ACCESS KEYS




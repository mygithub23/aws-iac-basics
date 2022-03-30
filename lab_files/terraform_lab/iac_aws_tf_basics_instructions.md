![INE Logo](https://ine.com/_next/image?url=%2Fassets%2Flogos%2FINE-Logo-Orange-White-Revised.svg&w=256&q=75)

# Deploying AWS resources with Terraform, from scratch!

[TOC]



<u>**SPECIAL NOTE:** If this lab is accomplished outside the INE supplied sandbox environment, INE is not and cannot be responsible for any charges from AWS for resources created by this lab.</u>



## Scenario / Introduction

Something broke in the cloud, and you need to fix it quickly!  And it's 3 AM! :weary: .  The workstation you use day-to-day for cloud engineering is not available, everything is going wrong, and everyone is looking at you to resolve the problem.  

>  Often in these situations, you are forced to deal with several other problems so that you can get back to resolving the original issue.  You must solve for getting the tools needed, getting templates, fixing a problem with the deployed resources, and finally ensuring your work is stashed back to a repo.  

This lab will build your basic skills and confidence using IaC and addressing chaotic situations promptly and efficiently.  You will learn how to set up a working environment with tooling quickly, deploy cloud resources using infrastructure as code, make an update, and then store our updated work.   

Let's start building!!!

----
----
### 1. Start Lab
***Instructions about starting the lab on the platform***

---

---



### 2. Set up your workstation

For a walkthrough of this section, see the video **Terraform: Demo / Lab Walthrough Workstation setup**.

| Step     | Instructions | Result |
| -------- | -------- | -------- |
| # 1      | Log in to the AWS Management Console using the provided student username and password. | Logged into the AWS console |
| # 2      | In the service search, type `cloudshell; in the list of services, select ***CloudShell***.  You can also click the icon for CloudShell on the ribbon bar. | The CloudShell console opens. |
| # 3      | Click ***Close*** in the Welcome card.| NA |
| # 4      | Ensure you are in the correct region in the top right of the AWS Console window.  You should be in `us-east-1`. | The Region selector shows *N. Virginia*. |
| # 5  | Run the following to install yum utilities: `sudo yum install -y yum-utils` |Yum's utilities are installed|
| # 6 | Run the following to configure the Hashicorp repository to git: `sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo` |Hashicorp's repository is available in this CloudShell session.|
| # 7 | Run the following to install Terraform: `sudo yum -y install terraform` |Terraform is now installed in CloudShell|
| # 8 | Verify your Terraform installation by running `terraform --version`.| The installed version of Terraform is displayed. |
| # 9 | Run `git --version` to see if git is installed.  If it is not installed, install git by running the following command:`sudo yum install git` | Git is installed |
| # 10 | Verify your git installation by running `git --version`. | The installed version of git is displayed. |

> ***Check-In:***  You now have a workstation with the tooling needed to deploy infrastructure.      
---
---

### 3. Fork/Clone GitHub repo

For a walkthrough of this section, see the video **Terraform: Demo / Lab Walkthrough Fork & Clone GitHub repo**.

| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| # 1  | Log into your own GitHub account | NA |
| # 2 | Navigate in browser to https://github.com/Internetworkexpert/cloud-aws-iac | NA |
| # 3 | Fork the repo into your own account by click the **Fork** button in the top left of the web page.  If you have access to multiple accounts in GitHub, a dialog box will open asking where the repo should be forked to.  Choose your own account or the account of your choice. | GitHub will redirect back to your directory with the cloud-aws-iac forked into your account. |
| # 4 | Back in your account, you will now have a forked copy of the *cloud-aws-iac* repo.  Click the **Code** button, and in the box that opens, copy the https string for cloning the repo (either select and copy or click the copy button to the right of the https URL). | The clone URL for your copy of the repo is copied. |
| # 5 | Back in CloudShell run `git clone <PASTE THE URL COPIED IN THE ABOVE STEP>.` | Your copy of the repo is cloned into CloudShell. |
| # 6 | Run the following command to change into the Terraform lab: `cd cloud-aws-iac/lab_files/terraform_lab/` | NA |

Run `ls -la` to see the files you just forked.  For an explanation of the files, watch the accompying demo/walk through video for this lab.

---
---

### Note: Terraform file review

For a review of the Terraform files in this lab and hey they contribute to creating the target AWS infrastructure, see the video **Terraform: Demo / Lab Walkthrough Template Discussion**.



---

---

### 4. Configure remote state

*For a walkthrough of this section, see the video **Terraform: Demo / Lab Walkthrough Configure remote state**.*

You now need to configure storage of the Terraform state files into remote storage: Amazon S3 and Amazon DynamoDB.  To do that we will modify the _backend.tf with an S3 bucket and DynamoDB table that we create.

| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| # 1   | Open a new tab in your browser and navigate to the AWS Console page.  Log in (if necessary) and then naviage to the Amazon S3 page | The Amazon S3 page opens                          |
| # 2 | Click the **Create bucket** button                           | The create bucket page is opened.                 |
| # 3 | For the bucket name, enter a name that should be unique.  You can append the date to the name to ensure it is unique such as: *terraform-state-20220601*.  Be sure to note the name you use since it will be needed to configure Terraform. | NA                                                |
| # 4 | Leave the remaining setting to their defaults, scroll to the bottom of the page and click the **Create bucket** button. | The bucket is created.                            |
| # 5 | In the **Search** textbox at the top of the page, enter Dyanmodb.  In the list of services that appears select **DynamoDB**. | The DynamoDB page is displayed.                   |
| # 6 | In the menu to the left click **Tables**, and when the tables page open click the **Create table** button. | The create table page is displayed.               |
| # 7 | On the create table page, enter a name for your table.  Some ideas are: *terraform_lock_table* or *terraformlocker*.  Anything should work as long as you following the rules for DynamoDB table names: *<u>Between 3 and 255 characters, containing only letters, numbers, underscores (_), hyphens (-), and periods (.).</u>* | NA |
| # 8 | In the **Partition key**, enter the value *LockID*, leave the data type as *String*. | NA |
| # 9 | Scroll to the bottom of the page and click the **Create table** button | You are navigated back to the DynamoDB tables page showing the new table is being creating. |
| # 10 | Note the name of this new table.  It will be used for configuring Terraform. | NA |

---

---

### 5. Update, initialize, format, and validate, plan and apply the template

For a walkthrough of this section, see the video **Terraform: Demo / Lab Walkthrough Update through applying & Update and apply**.

| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| # | In CloudShell, run `pwd` to ensure you are in the *cloud-aws-iac/lab_files/terraform_lab/* directory. | Running `pwd` returns `cloud-aws-iac/lab_files/terraform_lab/`.  If this is not the result, repeat step 3.6 above and then run `pwd` to ensure you are in the correct directory. |
| # | Edit the file (using nano or vim) *_backend.tf* replacing the values for **bucket** and **dynamodb_table**with the name of the bucket and table you created in section 4 above.  *(Note: If you are unfamiliar/uncomfortable with editing with nano or vim, see the section [Editing _backend.tf](#vim_backend.tf) at the bottom of these instructions.)* | The file _backend.tf shows the names of the S3 bucket and DynamoDB table created above. |
| # | Run the command `terraform init` to initialize the directory with the needed providers. | A message containing `Terraform has been successfully initialized!` will be printed on the screen. |
| # | Run the command `terraform fmt` to ensure the terraform template file is well-formatted. | The file name `main.tf` is written to the screen if no errors are found. |
| # | Run the command `terraform validate` | The message `"Success! The configuration is valid."`is written to the screen. |
| #  | Run the command `terraform plan`    | A large amount of data will be written on the screen.  Verify that a value is shown for the ami that will be created.  You should see the following at the end of the output: `Plan: 1 to add, 0 to change, 0 to destroy.` |
| #  | Run the command `terraform apply` to create the AWS resources. | Terraform prints out what it will deploy.|
| #  | Enter `yes` to the question `Do you want to perform these actions?`    | Terraform will be creating the resources and eventually write the following to the screen: `Apply complete! Resources: 1 added, 0 changed, 0 destroyed.`    |


Now that the apply is complete, let's see if the resource was created.  In the AWS Management Console navigate to the Amazon EC2 service.  Listed there should be an EC2 instance that is booting up.

Awesome!  You've deployed your EC2 instance to the cloud. 

---
---

### 6. Update and deploy

For a walkthrough of this section, see the video **Terraform: Demo / Lab Walkthrough Update through applying & Update and apply**.

> And another problem?!?!  After you deploy the server, the Security Department says you must update the Name tag to Finance_Mobile_Front_End.  Ugh!

Now we will update the instance by changing the `Name` tag to `Finance_Mobile_Front_End`.  We will be using vim to make the change.  Don't worry if you've never used vim before...I'll walk you through it. :wink:
| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| # 1   | Run the following: `vim main.tf`    | The vim editor opens the file main.tf |
| # 2   | Use the down arrow on your keyboard to the line in the file where `Name = "Finance_Front_End" is located.   | The cursor is now on the Name key-value entered in the file. |
| # 3   | Use your arrow key to put the cursor under the F in Front. | The cursor is now at the F in Front. |
| # 4   | Hit your Esc key and then hit the i key.    | This puts vim into insert mode. |
| # 5   | Type `Mobile_`    | The value for the Name tag will now be `Finance_Mobile_Front_End`. |
| # 6   | Press the Esc key again and then type `:wq` to write to the file and quit vim. | You will be returned to the command prompt.    |
| # 7   | Run `terraform plan`     | After a few moments, the plan will be written similar to the following: `Plan: 0 to add, 1 to change, 0 to destroy.` |
| # 8   | Run `terraform apply`    | Terraform begins the apply process. |
| # 9   | At the prompt for `Enter a value:` enter yes.    | Terraform completes updating the running EC2 instance.    |

Now let's verify the update.  Run the following command:
`aws ec2 describe-tags --output table`

When the table prints to the screen, scroll through the values, and you should see a row in the Key column named `Name` with the value (the last column) of `Finance_Mobile_Front_End`.

---

---



### 7. Commit and clean up

For a walkthrough of this section, see the video **Terraform: Demo / Lab Walthrough Commit changes and cleanup**

You've successfully deployed an EC2 instance, made a change, and now that everyone is happy, we need to stow our updates back to GitHub and clean everything up.  

BUT FIRST!!!...we have a little problem.  You will not be able to write back to your GitHub repo without a personal access token.  When you run `git push`, you will be prompted with a username and password.  The password is where you will enter the token.  The steps below include generating a token and adding to CloudShell.

| Step    | Instructions    | Result|
| -------- | -------- | -------- |
| # 1   | Run the command `terraform destroy` | After a few moments, the question `Do you really want to destroy all resources?` will be written, and the prompt will be at `Enter a value:`. |
| # 2   | Type yes to the prompt.    | Terraform terminates the instance.  This takes about a minute and will show the message `Destroy complete! Resources: 1 destroyed.` when completed.   |
| # 3   | Type `git add .` (don't forget the period) and press Enter. | git adds all files for pushing back to GitHub.    |
| # 4 | If not already logged in, log in to your GitHub account | You are logged into GitHub. |
| # 5 | On the GitHub page, click the drop-down in the top right of the page next to your avatar's picture | A drop-down menu appears. |
| # 6 | In the drop-down select *Settings*. | The Settings page appears. |
| # 7 | Scroll to the bottom of the menu on the left side of the page and click *Developer settings* | The Developer Settings page appears. |
| # 8 | On the left side of the page, in the menu, select *Personal access tokens* | The Personal access tokens page appears. |
| # 9 | Click the **Generate new token** | You may be prompted to re-enter your GitHub password.  Enter your password, click enter and the *New personal access token* page will appear. |
| # 10 | Enter a note to describe the purpose of this personal access token.  For example, *CloudFormation token* | NA |
| # 11 | In the expiration drop-down, set the expiration to 30 days (the default at the time of this writing). | NA |
| # 12 | For *Select scopes* select the top-level checkbox for *repo* | All of the checkboxes in the repo section are selected. |
| # 13 | Scroll to the bottom of the page and click the **Generate token** button. | The page with the new token appears. |
| # 14 | Copy the token (Ctrl-C).  Leave the page open until we are sure we have correctly copied and pasted the token into CloudShell | The page should be left open. |
|  |  |  |
| #  | Type `git commit -m "Updates tag for Name."` Then press Enter.    | A commit message is now associated with the change.    |
| #   | Type `git push` and then Enter.    | The updated template is written back to GitHub.    |
| # | Enter your GitHub username when prompted and press enter. | You are prompted for your GitHub password. |
| # | Paste in your GitHub personal access token you generated above and press enter. | The git command completes showing that updates have been pushed back to GitHub. |

---

---

### Bonus: Editing _backend.tf  with vim <a name="vim_backend.tf"></a>

For a walkthrough of this section, see the video **Terraform: Demo / Lab Walkthrough Bonus: Editing _backend.tf with vim**.

This section will cover the step-by-step for editing the _backend.tf file using vim.  Each step is spelled out so, if you are not familiar with vim, you will begin to build the skill necessary to be confident using the editor.

| Step | Instructions                                                 | Result                                                       |
| ---- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| # 1  | Begin by ensuring you are in the cloud-aws-iac/lab_files/terraform_lab/ direction | NA                                                           |
| # 2  | Open the file by typing `vim _backend.tf`                    | The state store configuration file is opened in vim.         |
| # 3  | Using the arrow keys, move the cursor to the value for the **bucket** value.  Ensure the cursor is flashing under the first character of the value (just after the first double quote.). | The cursor is under the first letter in the default value for the bucket variable. |
| # 4  | Hit the 'x' key to delete, character by character, the value for bucket. | The value for the bucket variable is now an empty string.  Just "". |
| # 5  | Hit the Esc key and then the 'i' key to enter insert mode in vim. | NA                                                           |
| # 6  | Type the value of the bucket your created.                   | The value for bucket is now the name of the bucket created above.  For example: `bucket = "mybucketname"` |
| # 7  | Hit Esc again to enter command mode in vim.                  | NA                                                           |
| # 8  | Move the cursor as before so you the cursor is under the first letter for the value of the **dynamodb_table** variable. | The cursor is under the first letter in the default value for the DynamoDB table variable. |
| # 9  | Hit the 'x' key to delete, character by character, the value for DynamoDB table. | The value for the DynamoDB variable is now an empty string.  Just "". |
| # 10 | Hit the Esc key and then the 'i' key to enter insert mode in vim. | NA                                                           |
| # 11 | Type the value of the DynamoDB table you created.            | The value for the DynamoDB table is now the name of the table created above.  For example: `dynamodb_table == "my dynamo-table"`. |
| # 12 | Hit the Esc key, and then `:wq` to write and quite vim.      | The file is saved and the vim editor is exited.              |
| # 13 | Run `cat _backend.tf` and inspect the output to ensure the values you entered for the S3 bucket and DynamoDB table are accuratetly displayed in the file. | The names of of the S3 bucket and DynamoDB table created above appear in the file for the bucket and dynamodb_table variables. |




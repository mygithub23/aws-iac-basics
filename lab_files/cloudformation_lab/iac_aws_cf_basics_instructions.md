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

   1. Describe CloudFormation resources
   2. List resources in CloudFormation
   3. Get information about resources in CloudFormation

   <u>Policy B:</u>

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
| #5   | In the Designer, at the bottom click the *template* tab and paste in the JSON listed at the bottom of these instructions. | The JSON appears in the template tab and resources appear on the work surface. |
| #6   | Click the *Create Stack* icon.  It is the small cloud with an arrow pointing up, just above the resource types list on the left side of the page. | CloudFormation returns to the *Create stack* page.  The Amazon S3 URL textbox will be populated with the S3 key of the JSON template. |
| #7   | Click *Next*                                                 | The *Specify stack details* page is displayed                |
| #8   | In the *Stack name* textbox enter `cf_security_demo`         | NA                                                           |
| #9   | In the password field enter a password.  Ensure the password has the following: an upper case letter, a lower case letter, a number, and a special character. | NA                                                           |
| #10  | Click *Next*                                                 | NA                                                           |
| #11  | Scroll to the bottom of the *Configure stack options* page and click Next. | The Review page is displayed.                                |
| #12  | On the *Review cf_security_demo* page, scroll to the bottom and click the acknowledgment box for creating IAM::Group resources. | NA                                                           |
| #13  | Click the *Create Stack* button at the bottom of the page    | You are returned to the CloudFormation page where the output from the stack creation is shown. |
|      |                                                              |                                                              |





## JSON Template

` {
    "AWSTemplateFormatVersion": "2010-09-09",
    "Description": "",
    "Parameters": {
        "Password": {
            "NoEcho": "true",
            "Type": "String",
            "Description": "New account password",
            "MinLength": "1",
            "MaxLength": "41",
            "ConstraintDescription": "the password must be between 1 and 41 characters"
        }
    },
    "Resources": {
        "CFNUser": {
            "Type": "AWS::IAM::User",
            "Properties": {
                "LoginProfile": {
                    "Password": {
                        "Ref": "Password"
                    }
                }
            },
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "c4d726eb-0764-48db-81f7-da90c6586ced"
                }
            }
        },
        "CFNUserGroup": {
            "Type": "AWS::IAM::Group",
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "8107ba84-d1d9-41a5-b0fe-3da6a31769b2"
                }
            }
        },
        "CFNAdminGroup": {
            "Type": "AWS::IAM::Group",
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "0eab1eca-6c3c-48ae-b773-5a4fa2ddf83b"
                }
            }
        },
        "Users": {
            "Type": "AWS::IAM::UserToGroupAddition",
            "Properties": {
                "GroupName": {
                    "Ref": "CFNUserGroup"
                },
                "Users": [
                    {
                        "Ref": "CFNUser"
                    }
                ]
            },
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "0beec6a5-272a-457a-b583-f39d3574362f"
                }
            }
        },
        "Admins": {
            "Type": "AWS::IAM::UserToGroupAddition",
            "Properties": {
                "GroupName": {
                    "Ref": "CFNAdminGroup"
                },
                "Users": [
                    {
                        "Ref": "CFNUser"
                    }
                ]
            },
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "a7c16162-42dc-456a-8155-9e08dcce599f"
                }
            }
        },
        "CFNUserPolicies": {
            "Type": "AWS::IAM::Policy",
            "Properties": {
                "PolicyName": "CFNUsers",
                "PolicyDocument": {
                    "Statement": [
                        {
                            "Effect": "Allow",
                            "Action": [
                                "cloudformation:Describe*",
                                "cloudformation:List*",
                                "cloudformation:Get*"
                            ],
                            "Resource": "*"
                        }
                    ]
                },
                "Groups": [
                    {
                        "Ref": "CFNUserGroup"
                    }
                ]
            },
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "d566a6c0-765a-47cd-aacd-ea8bf07f30b4"
                }
            }
        },
        "CFNAdminPolicies": {
            "Type": "AWS::IAM::Policy",
            "Properties": {
                "PolicyName": "CFNAdmins",
                "PolicyDocument": {
                    "Statement": [
                        {
                            "Effect": "Allow",
                            "Action": "cloudformation:*",
                            "Resource": "*"
                        }
                    ]
                },
                "Groups": [
                    {
                        "Ref": "CFNAdminGroup"
                    }
                ]
            },
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "df0ccb35-a865-4ae7-a79b-85ac834b800d"
                }
            }
        },
        "CFNKeys": {
            "Type": "AWS::IAM::AccessKey",
            "Properties": {
                "UserName": {
                    "Ref": "CFNUser"
                }
            },
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "83ecdcfb-048c-44a5-b1c2-fa8a09625ef0"
                }
            }
        }
    },
    "Outputs": {
        "AccessKey": {
            "Value": {
                "Ref": "CFNKeys"
            },
            "Description": "AWSAccessKeyId of new user"
        },
        "SecretKey": {
            "Value": {
                "Fn::GetAtt": [
                    "CFNKeys",
                    "SecretAccessKey"
                ]
            },
            "Description": "AWSSecretKey of new user"
        }
    },
    "Metadata": {
        "AWS::CloudFormation::Designer": {
            "0eab1eca-6c3c-48ae-b773-5a4fa2ddf83b": {
                "size": {
                    "width": 60,
                    "height": 60
                },
                "position": {
                    "x": -40,
                    "y": 100
                },
                "z": 1,
                "embeds": []
            },
            "df0ccb35-a865-4ae7-a79b-85ac834b800d": {
                "size": {
                    "width": 60,
                    "height": 60
                },
                "position": {
                    "x": 100,
                    "y": 70
                },
                "z": 1,
                "embeds": [],
                "isassociatedwith": [
                    "0eab1eca-6c3c-48ae-b773-5a4fa2ddf83b"
                ]
            },
            "8107ba84-d1d9-41a5-b0fe-3da6a31769b2": {
                "size": {
                    "width": 60,
                    "height": 60
                },
                "position": {
                    "x": -110,
                    "y": 330
                },
                "z": 1,
                "embeds": []
            },
            "d566a6c0-765a-47cd-aacd-ea8bf07f30b4": {
                "size": {
                    "width": 60,
                    "height": 60
                },
                "position": {
                    "x": -230,
                    "y": 330
                },
                "z": 1,
                "embeds": [],
                "isassociatedwith": [
                    "8107ba84-d1d9-41a5-b0fe-3da6a31769b2"
                ]
            },
            "c4d726eb-0764-48db-81f7-da90c6586ced": {
                "size": {
                    "width": 60,
                    "height": 60
                },
                "position": {
                    "x": 30,
                    "y": 180
                },
                "z": 1,
                "embeds": []
            },
            "83ecdcfb-048c-44a5-b1c2-fa8a09625ef0": {
                "size": {
                    "width": 60,
                    "height": 60
                },
                "position": {
                    "x": -230,
                    "y": 250
                },
                "z": 1,
                "embeds": []
            },
            "a7c16162-42dc-456a-8155-9e08dcce599f": {
                "size": {
                    "width": 60,
                    "height": 60
                },
                "position": {
                    "x": -230,
                    "y": 140
                },
                "z": 1,
                "embeds": [],
                "isassociatedwith": [
                    "c4d726eb-0764-48db-81f7-da90c6586ced",
                    "0eab1eca-6c3c-48ae-b773-5a4fa2ddf83b"
                ]
            },
            "0beec6a5-272a-457a-b583-f39d3574362f": {
                "size": {
                    "width": 60,
                    "height": 60
                },
                "position": {
                    "x": -30,
                    "y": 250
                },
                "z": 1,
                "embeds": [],
                "isassociatedwith": [
                    "c4d726eb-0764-48db-81f7-da90c6586ced",
                    "8107ba84-d1d9-41a5-b0fe-3da6a31769b2"
                ]
            }
        }
    }
} `


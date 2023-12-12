# devops-fully-automated-infra
Fully automated and secured Terraform infra pipeline

Testing teh webhook.....

## CICD Infra setup
1) ###### GitHub setup
    Fork GitHub Repository by using the existing repo "devops-fully-automated-infra" (https://github.com/cvamsikrishna11/devops-fully-automated-infra)     
    - Go to GitHub (github.com)
    - Login to your GitHub Account
    - **Fork repository "devops-fully-automated-infra" (https://github.com/cvamsikrishna11/devops-fully-automated-infra.git) & name it "devops-fully-automated-infra"**
    - Clone your newly created repo to your local

2) ###### Jenkins
    - Create an **Amazon Linux 2 VM** instance and call it "Jenkins"
    - Instance type: t2.large
    - Security Group (Open): 8080, 9100 and 22 to 0.0.0.0/0
    - Key pair: Select or create a new keypair
    - **Attach Jenkins server with IAM role having "AdministratorAccess"**
    - User data (Copy the following user data): https://github.com/cvamsikrishna11/devops-fully-automated/blob/installations/jenkins-maven-ansible-setup.sh
    - Launch Instance
    - After launching this Jenkins server, attach a tag as **Key=Application, value=jenkins**

3) ###### Slack 
    - **Join the slack channel https://join.slack.com/t/slack-wcl4742/shared_invite/zt-1kid01o3n-W47OUTHBd2ZZpSzGnow1Wg**
    - **Join into the channel "#team-devops"**

### Jenkins setup
1) #### Access Jenkins
    Copy your Jenkins Public IP Address and paste on the browser = ExternalIP:8080
    - Login to your Jenkins instance using your Shell (GitBash or your Mac Terminal)
    - Copy the Path from the Jenkins UI to get the Administrator Password
        - Run: `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
        - Copy the password and login to Jenkins
    - Plugins: Choose Install Suggested Plugings 
    - Provide 
        - Username: **admin**
        - Password: **admin**
        - Name and Email can also be admin. You can use `admin` all, as its a poc.
    - Continue and Start using Jenkins

2)  #### Plugin installations:
    - Click on "Manage Jenkins"
    - Click on "Plugins"
    - Click "Available Plugins"
    - Search and Install the following Plugings "Install Without Restart"        
        - **Slack Notification**



3)  #### Pipeline creation
    - Click on **New Item**
    - Enter an item name: **app-infra-pipeline** & select the category as **Pipeline**
    - Now scroll-down and in the Pipeline section --> Definition --> Select Pipeline script from SCM
    - SCM: **Git**
    - Repositories
        - Repository URL: FILL YOUR OWN REPO URL (that we created by importing in the first step)
        - Branch Specifier (blank for 'any'): */main
        - Script Path: Jenkinsfile
    - Save



4)  #### Credentials setup(Slack):
    1)  #### Configure slack credentials for the pipeline to post alerts on slack channel:
        - Click on Manage Jenkins --> System
        - Go to section Slack
        - Workspace: **devopsfullyau-r0x2686** (if not working try with name of workspace devops-fully-automated)
        - Credentials: Click on Add button to add new credentials
            - Slack secret token (slack-token)
            - Kind: Secret text            
            - Secret: 3jrfd3GjdMac0dgcxJwcOgQU
            - ID: slack-token
            - Description: slack-token
            - Click on Create        


### GitHub webhook

1) #### Add jenkins webhook to github
    - Access your repo **devops-fully-automated-infra** on github
    - Goto Settings --> Webhooks --> Click on Add webhook 
    - Payload URL: **htpp://REPLACE-JENKINS-SERVER-PUBLIC-IP:8080/github-webhook/**             (Note: The IP should be public as GitHub is outside of the AWS VPC where Jenkins server is hosted)
    - Click on Add webhook

2) #### Configure on the Jenkins side to pull based on the event
    - Access your jenkins server, pipeline **app-infra-pipeline**
    - Once pipeline is accessed --> Click on Configure --> In the General section --> **Select GitHub project checkbox** and fill your repo URL of the project devops-fully-automated.
    - Scroll down --> In the Build Triggers section -->  **Select GitHub hook trigger for GITScm polling checkbox**

Once both the above steps are done click on Save.


### Codebase setup

1) #### For checking the checkov scan uncomment lines 74-78 in ec2/ec2.tf file
    - Go back to your local, open your "devops-fully-automated" project on VSCODE
    - Open "ec2.tf file" uncomment lines   
    - Save the changes in both files
    - Finally push changes to repo
        `git add .`
        `git commit -m "relevant commit message"`
        `git push`

2) #### Skipping all the checks on the Jenkins file comment the checkov scan lines accordingly with # (sure to shell)

## Finally observe the whole flow and understand the integrations :) 

### Destroy the infra

1) #### Once the flow is observed, lets destroy the infra with same code
    - Go back to your local, open your "devops-fully-automated" project on VSCODE
    - Open "Jenkinsfile" comment lines 59, 76-82 & uncomment lines 61, 84-90
    - Save the changes in both files
    - Finally push changes to repo
        `git add .`
        `git commit -m "relevant commit message"`
        `git push`

2) #### Terminate Jenkins EC2 instance

# Happy learning, everyone 😊 😊

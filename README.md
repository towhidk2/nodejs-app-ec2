<div align="left">
  <h3>NodeJS Sample Application</h3>
  <strong>
      In this project I demonstrated how to deploy a containerized nodejs application using docker compose in production. Here I have used various devops tools like Jenkins for task automation, terraform for infrastructure provisioning, sonarqube for code analysis, python boto3 for custom ami creation etc. Also I have used other tools like Terraform for infrastructure automation, ansible for task automation, and various aws tools for EC2 autoscaling, application loadbalancer etc. On the whole I have tried to used tools that are required for production deployment of a nodejs application.
  </strong>
</div>
<br>

# Run the application on local development environment
```
cd nodejs-app-ec2
npm install
npm start
```
<br>

# Production Deployment
Production deployement starts after devloper pushes code to github to a specific branch. 

## Create a CI/CD pipeline in Jenkins for production deployment
Jenkins pipeline do the all the taks required from code build to production deployment. For the explanation purpose I separated Jenkins pipeline into two parts one is for custom AMI creation and other is for production deployment.

<br>

## Steps to create the custom AMI for nodejs sample application
1. Developer pushes code to SCM
2. Build the code
3. Test the code
4. Analyze the code
5. Create docker image from the code
6. Push image to the docker registry
7. Create a EC2 instance 
8. Install necessary software on the EC2
9. Deploy docker image on EC2 with docker compose
10. Finally create custom AMI using python boto3 library 

For the purpose of testing we can generate custom AMI seperately so that it can be checked. To create custom AMI run following commands.
```
cd nodejs-app-ec2
make ami
```

<br>

## Tools Used in Production Deployment
1. Cloud plaftform AWS
2. Terraform
3. Custorm VPC with Internet Gateway, Public and Private Subnets
4. Git, GitHub
5. Docker, DockerHub
6. SonarQube Cloud
7. EC2 LaunchTemplate
8. EC2 AutoScaling group
9. Scale in and Scale out policies
10. EC2 Target Group
11. Application LoabBalancer
12. AWS Certificate Manager
13. Route53
14. Security Groups
15. Jenkins
16. Slack Notification

For the purpose of testing we can run the production deployment after creation of custom AMI. Run the following commands to deploy in production.
```
cd nodejs-app-ec2
make autoscale
```
<br>

# Clean Up
To destroy all the created insfrastructures run following commands.
```
cd nodejs-app-ec2
make destroy_autoscale
```

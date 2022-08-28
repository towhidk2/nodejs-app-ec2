<div align="center">
  <h1>NodeJS Sample Application</h1>
  <strong>This repository is an attempt for setting up a complete CI/CD pipeline using Jenkins, Docker and AWS EC2</strong>
</div>

<hr>

# Steps to Create Custom AMI
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

# Tools Used in Production Deployment
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


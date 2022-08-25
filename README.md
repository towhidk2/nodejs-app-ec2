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
2. Custorm VPC with Internet Gateway, Public and Private Subnets
3. Git, GitHub
4. Docker, DockerHub
5. SonarQube Cloud
6. EC2 LaunchTemplate
7. EC2 AutoScaling group
8. EC2 Target Group
9. Application LoabBalancer
10. AWS Certificate Manager
11. Route53
12. Security Groups



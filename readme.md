# Terraform to provision the AWS API Gateway with Custom Lambda Authorizer

This project sets up an AWS API Gateway and a custom Lambda authorizer using Terraform. The Lambda function is written in Node.js and is designed to authorize API requests based on the provided authorization token.

## Overview

The API Gateway serves as the entry point for API requests, which are then authenticated and authorized by the Lambda authorizer. The authorizer extracts and logs the token and other request details for validation.

## Prerequisites

- AWS Account
- AWS CLI configured with appropriate credentials
- Terraform >= 0.14
- Node.js >= 12.x

## Installation & Deployment

### Step 1: Clone this repository to your local machine:
```bash
git clone https://your-repository-url.git
cd your-repository-path

### Step 2: Initialize Terraform
Initialize a Terraform working directory:

terraform init

### Step 3: Apply Terraform Configuration
Apply the Terraform configuration to provision the AWS resources:

terraform apply

## Lambda Authorizer Functionality

The Lambda authorizer function receives the authorization token along with the event object. It prints and checks these values:

event.type
event.methodArn
event.authorizationToken
The function is triggered whenever a request is made to the API Gateway and it evaluates the provided token to authenticate the request.

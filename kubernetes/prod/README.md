# _Setup new project:_

### 1. Database:
* Create the database and store information about: 
  * host name
  * database username and password
  * database port
  * the name of the database
* I would recommend using the AWS RDS as the database for this project.

### 2. Payment method:
* Create the braintree account and store the information about:
  * merchant id
  * public key
  * private key

### 3. Social login:
* Create a Google application and store the information about:
  * client id
  * secret

### 4. Django Secret key:
* Create a django secret as the sha256 string

### 5. Mail provider:
* Create an application password of your mail provider, I'm using gmail for this

### 6. Static storage:
* Create an AWS S3 bucket and store the bucket name

# _Don't skip this step:_
* Finally, create SSM Parameters Store to store all these things follow the exact key below:
  * /donggiang_store/DATABASE_ENGINE
  * /donggiang_store/DATABASE_HOST
  * /donggiang_store/DATABASE_USERNAME
  * /donggiang_store/DATABASE_PASSWORD
  * /donggiang_store/DATABASE_PORT
  * /donggiang_store/DATABASE_NAME
  * /donggiang_store/DJANGO_SECRET_KEY
  * /donggiang_store/BRAINTREE_MERCHANT_ID
  * /donggiang_store/BRAINTREE_PUBLIC_KEY
  * /donggiang_store/BRAINTREE_PRIVATE_KEY
  * /donggiang_store/DJANGO_SUPERUSER_EMAIL
  * /donggiang_store/DJANGO_SUPERUSER_PASSWORD
  * /donggiang_store/GOOGLE_CLIENT_ID
  * /donggiang_store/GOOGLE_SECRET
  * /donggiang_store/EMAIL_HOST_USER
  * /donggiang_store/EMAIL_HOST_PASSWORD
  * /donggiang_store/AWS_STORAGE_BUCKET_NAME
* The key pattern is `<ssm_prefix>/<key_name>`
  * The ssm_prefix can be changed on the settings.py at line 62
  * The key_name must be kept as the origin.

### _Create the Kubernetes cluster on cloud provider_
* Create the AWS EKS to deploy our application (change the char "\`" to "\\" if you use the linux shell): required `eksctl` is already installed. Follow [this instruction](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html) to install it.
  ```powershell
  eksctl create cluster `
    --name capstone `
    --region us-east-1 `
    --zones us-east-1a,us-east-1b,us-east-1c,us-east-1d `
    --asg-access `
    --full-ecr-access `
    --alb-ingress-access `
    --instance-prefix donggiang-store `
    --node-type t3.medium `
    --nodes 1 `
    --nodes-min 1 `
    --nodes-max 10 `
    --max-pods-per-node 17 `
    --node-ami-family Ubuntu2004 `
    --timeout 60m
  ```
* Connecting to the existing EKS cluster
  ```commandline
  aws eks update-kubeconfig --name capstone --region us-east-1
  ```
### _Environment variable for the pipeline_
* The current pipeline also needs these variables to work as expected:
  * AWS_ACCESS_KEY_ID
  * AWS_ACCOUNT_ID
  * AWS_DEFAULT_REGION
  * AWS_SECRET_ACCESS_KEY
  * DOCKER_HUB_ID
  * DOCKER_HUB_PASSWORD
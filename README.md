# Web-App-DevOps-Project

Welcome to the Web App DevOps Project repo! This application allows you to efficiently manage and track orders for a potential business. It provides an intuitive user interface for viewing existing orders and adding new ones.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Technology Stack](#technology-stack)
- [Contributors](#contributors)
- [License](#license)

## Features

- **Order List:** View a comprehensive list of orders including details like date UUID, user ID, card number, store code, product code, product quantity, order date, and shipping date.
  
![Screenshot 2023-08-31 at 15 48 48](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/3a3bae88-9224-4755-bf62-567beb7bf692)

- **Pagination:** Easily navigate through multiple pages of orders using the built-in pagination feature.
  
![Screenshot 2023-08-31 at 15 49 08](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/d92a045d-b568-4695-b2b9-986874b4ed5a)

- **Add New Order:** Fill out a user-friendly form to add new orders to the system with necessary information.
  
![Screenshot 2023-08-31 at 15 49 26](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/83236d79-6212-4fc3-afa3-3cee88354b1a)

- **Data Validation:** Ensure data accuracy and completeness with required fields, date restrictions, and card number validation.

## Getting Started

### Prerequisites

For the application to succesfully run, you need to install the following packages:

- flask (version 2.2.2)
- pyodbc (version 4.0.39)
- SQLAlchemy (version 2.0.21)
- werkzeug (version 2.2.3)

### Usage

To run the application, you simply need to run the `app.py` script in this repository. Once the application starts you should be able to access it locally at `http://127.0.0.1:5000`. Here you will be meet with the following two pages:

1. **Order List Page:** Navigate to the "Order List" page to view all existing orders. Use the pagination controls to navigate between pages.

2. **Add New Order Page:** Click on the "Add New Order" tab to access the order form. Complete all required fields and ensure that your entries meet the specified criteria.

## Technology Stack

- **Backend:** Flask is used to build the backend of the application, handling routing, data processing, and interactions with the database.

- **Frontend:** The user interface is designed using HTML, CSS, and JavaScript to ensure a smooth and intuitive user experience.

- **Database:** The application employs an Azure SQL Database as its database system to store order-related data.

### The Process

## The Dockerfile

**Containerisation process** 

- Use FROM to specify choose an official image and specify the version after the colon. This initiates the build.
- WORKDIR specifies the directory in the container.
- COPY copies the files from the location on your machine to the location in the container which ensures that the required files are available in the container. In this case, this copies the current directory on your local machine to the working directory in the container (/app).
- The two RUN steps that follow install the necessary dependencies and ODBC driver which is needed to obtain order data from the Azure SQL database server.
- The next RUN step uses `pip install` to install the dependencies from the requirements.txt file.
- EXPOSE makes this port available inside the container. In this case, this is port 5000.
- CMD is the instruction to run. Here I use the "python app.py" which will run the flask app specified in the app.py file.

**Docker commands**

- To build this image use the command: `docker build -t <image-name>`.
- We use `python:slim-3.8`.
- To use port 5000 locally and run the image use the command: `docker run -p 5000:5000 <image-name>`
- This makes the app available at `http://127.0.0.1:5000`
- Tag the image using the command: docker tag <image-name> <docker-hub-username>/<image-name>:<tag>
- Here, `<tag>` is the version of the image, which we can replace with `latest`.  Specify your Docker Hub username in place of `<docker-hub-username>`.
- I have called my image `custom-image` and the version `latest`.
- To push the image to Docker Hub use the command: `docker push <username>/<image>:<tag>`
- Check that the image has indeed been pushed to Docker Hub by logging in and clicking on the repository.
- You can pull the image using the command: `docker pull <docker-hub-username>/<image-name>`
- Run your image locally with the "docker run" command (using port 5000) to check it has the expected result, which in this case is being able to access the app at `http://127.0.0.1:5000`
- For efficient resource use, any unused containers and images may be removed.
- You can stop containers using `docker stop <container_id>` and then remove it using `docker rm <container_name>`. View this information using `docker ps -a`.
- Use the command `docker images -a` to view all images and remove any using `<docker rmi image_id>`
- Note that if changes are made to app.py, the the command `docker build -t <image-name> .` should be used to rebuild the image.

## Networking Services using Infrastructure as Code (IaC)

The aks-terraform directory contains the necessary IaC. This contains a main.tf and variables.tf file. In addition it contains two directories: the `aks-cluster-module` directory and `networking-module` directory.

Make sure to add `terraform.tfstate`, `terraform.tfstate.backup` to your .gitignore to avoid accidentally uploading credentials to GitHub. Add `.terraform` to your .gitignore file as well since it is a large file. Push this file to GitHub before the next parts of the directory.

This main.tf file begins with the authentication credentials required for terraform to provision the resources. To use this code, you will need to use your subscription information. You will also need to update your .bashrc file with your `client_id` and `client_secret`. Variables to access the `client_id` and `client_secret` are in the variables.tf file. It is very important not to put your `client_id` and `client_secret` on GitHub, so these are included as environment variables in the variables.tf file, and must be added to your .bashrc or .zshrc file so that they can be accessed by terraform. 

The main.tf file also combines the variables listed in the two directories within it, using the input variables from the networking_module and the output variables from the aks-cluster-module.

**Terraform commands**

Make sure you are in the aks-terraform directory. Run `terraform init`. You should get a message indicating that terraform has been successfully initialised.

I initially encountered an error when running this command. I had to add my service principal as a "Contributor" to my Azure subscription. I did this using Access Control then Role Assignments. Then, I was able to run `terraform init` successfully. 

When you run `terraform plan`, this should indicate the provision 8 resources, which can then be provisioned using the command `terraform apply`. Once created, the `aks-terraform-cluster` should be visible on the Azure portal.


## AKS

**Networking module** 
The networking module uses the following input variables as specified in the networking/variables.tf file:
- `resource_group_name`: This is the name of the Azure Resource Group where the networking resources will be deployed in
- `location`: The location where the networking resources will be deployed to
- `vnet_address_space`: This is for the Virtual Network

The networking module defines the following networking resources:
- Azure Resource Group: This is where the networking resources will be deployed
- Virtual Network (VNet)
- Control Plane Subnet
- Worker Node Subnet
- Network Security Group (NSG)

Within the NSG, we have two rules: the kube-apiserver-rule and the ssh-rule. You must change the public ip address to your own to only allow traffic from your ip address.

The networking module output variables as specified in the output.tf file:
- `vnet_id`
- `control_plane_subnet_id`
- `worker_node_subnet_id`
- `networking_resource_group_name`
- `aks_nsg_id`

## The Kubernetes Deployment
In the application_manifest.yaml file I define a Deployment manifest and a Service manifest.

The deployment manifest specifies an external artifact where the Docker image should be retrieved from. It also specifies the container port. I have included `RollingUpdate` as the deployment strategy. This means that pods are gradually replaced which means increases the app's reliability. The parameters I have included ensures that there is always one pod running. This is because a maximum of one extra pod may be created, and a maximum of one pod may be terminated during this update. (Note that this follows from the replicas specified being 2.)

We use `---` operator between the services so that we can define them in the same YAML file. 

The service manifest indicates the ports needed locally and for the container, which in this case is port 5000 for both. It also specified `ClusterIP`. Using this service means the app is only accessible internally, from your local machine and by anyone with access rights to the cluster.

## Extending Usage
Should the app need to be made the app available to external users, this could be achieved using an `Ingress` service instead of `ClusterIP` in the `application_manifest.yaml` file. This would make the app accessible externally via the specified port. Ingress uses SSL termination which deals with encrypted traffic and improves security.

## The Continuous Integration and Continuous Deployment (CI/CD) processes
Now we automate the containerisation and deployment process.

Create a new project in Azure DevOps. Under Organisations then Billing, make sure you have billing set up to fund resources. Without this, you will experience issues when attempting to run pipelines later on in the process.

 Under Pipelines, you can create a new pipeline. You can select a source repository. I have picked my GitHub repository and authorised Azure to link to the specific repository Web-App-DevOps-Project. 

## Docker Hub Integration
It is an important security measure to set up a service connection between Azure DevOps and your Docker Hub account.

In Docker Hub, you can go to Security in your Account Settings and click "New Access Token". This needs to have Read, Write and Delete permissions. Copy this and keep it safe.

Now, having followed the above steps, go to Project Settings then Security then under Pipelines click "New Service Connection". Choose "Docker Registry".
- Registry type: Docker Hub
- Docker ID: your Docker Hub username
- Password: the personal access token generated previously

## The Build Stage
I use the Starter Pipeline, and clear the section after "steps". Then I search for "Docker Task" and fill in the criteria.
- Select the Docker Hub service connection.
- Specify the Container Repository where the Docker image will be pushed to in the format "Docker_id/container_name".
- Choose the `buildAndPush` command.
- In the "Tags" field, put "latest".
- The Context will already be set as the root directory, so in this case will be aks-terraform. 

After filling in these fields click "Add" and "Save" committing this to the main branch, which will add the deployment task to your existing pipeline. Then run the pipeline. Successful execution is indicated by green ticks in the "Jobs" section. Go to Docker Hub to check that the new image is available.

## Azure DevOps and AKS service connection
On Azure DevOps, navigate to Service Connection which will be in the Pipelines section of Project settings. Click "Create Service Connection". I chose "Secure Principal (manual)" as the Authentication method. Then fill in the criteria. Test then save the connection.

## The Release Stage
Edit the pipeline on Azure DevOps by adding the "Deploy to Kubernetes" task. To do this, search for the task and fill in the fields.
- Pick "Docker Hub" as your the Container Registry since that is where the image is hosted.
- Pick "Azure Resource Manager" as the Connection Type since we are working with an Azure cluster.
- Choose the Azure Subscription associated with the AKS cluster.
- Enter the name of the Azure resource group where the cluster is located.
- Enter the name of the AKS cluster: aks-terraform
- Enter the name of the manifests: manifest_deployment.yml

Save and run the pipeline, adding this to the main branch. You can use kubectl pods to check the status of the deployment.

## Verification
Now any change made locally to the aks-terraform directory that is pushed to the GitHub repository will automatically initiate the Azure DevOps pipeline, and the Docker image will be rebuilt and pushed, and the cluster deployed.



## Contributors 

- [Maya Iuga]([https://github.com/yourusername](https://github.com/maya-a-iuga))

## License

This project is licensed under the MIT License. For more details, refer to the [LICENSE](LICENSE) file.

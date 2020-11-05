# eksHelm

This project is a demonstration of a kubernetes cluster using a helm chart for configuration  

## Terraform Instructions
Before we set up our kubernetes cluster, we must first create our ifrastructure to host our cluster. This project uses terraform to build the infrastructure on AWS.
- First we must set our desired variables inside the .tfvars file. There are two files, dev.tfvars and prod.tfvars. You can set different variables for different environments. Here you set how many subnets you want and what cidr ranges they will have. [The number of subnets is determined by how many cidr ranges you set] This is also where you set how many nodes(EC2 instances) you would like in your node group.
- Next all you need to do is apply the terraform template. To do so, type in the command: **terraform apply -var-file=<name of tfvars file>**
*Note: Terraform will take a long time to create the kubernetes cluster and node group. Just hang in there.
- Finally, all you need to do is configure your kubeconfig file. To do that, type in the command: **aws eks --region <region name>  update-kubeconfig --name <name of your eks cluster>**

## Helm Instrustions
This project uses helm to build a chart that configures our kubernetes deployment and service for us. Charts are helpful for easily sharing, packaging, configuring, and deploying applications and services onto Kubernetes clusters. 
- First we must set our desired variables for our helm chart. There is a values.yaml file that contains these variables. That is where you can set how many replicas you want, type of service, image, names and ports. 
- There is a Chart.yaml file that contains metadata for your chart. You can change what version of your chart you are using or what version of your app you are deploying.
- The two files that actually create your kubernetes cluster are under templates: deployments.yaml and service.yaml. 
The deployments file configures the type of image for your containers and number of replicas of that container.
The service file configures what service type and port your kubernetes cluster will use to access your container and expose it to the world.
- Now that the helm chart is configured, you need to install the chart. Type in the command: **helm install <name of the app> <name of the chart>**

## Clean Up
To delete this project, first you must delete the kubernetes cluster: **helm delete <name of the app>**
Then you can destroy the terraform template: **terraform destroy -var-file=<name of the tfvars file>**

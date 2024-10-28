
# Model Training and Deployment Pipeline


This repository contains a fully automated pipeline for training, selecting, and deploying machine learning models in a Kubernetes environment. The setup includes Dockerized applications, Kubernetes configurations, and custom scripts to facilitate reproducible model training, model selection, and deployment workflows.

The primary goal of this pipeline is to provide a production-like environment where models can be trained, evaluated, and deployed, emulating real-world scenarios.

## Repository Structure

```├── dockerfiles/
│   ├── Dockerfile-best-model          # Dockerfile for model selection container
│   ├── Dockerfile-deploy              # Dockerfile for model deployment container
│   └── Dockerfile-train               # Dockerfile for model training container
├── k8s/
│   ├── deployment.yaml                # Deployment configuration for Kubernetes
│   ├── hpa-config.yaml                # Horizontal Pod Autoscaler configuration
│   ├── KUBE_CONFIG_DATA-certificate-based-sample.yaml  # Sample K8s config (certificate-based auth)
│   ├── KUBE_CONFIG_DATA-token-based-sample.yaml        # Sample K8s config (token-based auth)
│   ├── load-balancer-service.yaml     # Service configuration with LoadBalancer
│   ├── model-selection-job.yaml       # Job configuration for selecting the best model
│   ├── persistent-volume-claim.yaml   # PVC configuration for model storage
│   └── persistent-volume.yaml         # PV configuration for model storage
├── pythonscripts/
│   ├── requirements-serve-model.txt   # Python dependencies for serving model
│   ├── requirements-train.txt         # Python dependencies for training
│   ├── select_best_model.py           # Script to identify and save the best model
│   ├── serve_model.py                 # Script to serve the selected model
│   └── train.py                       # Script to train the model and log metrics
├── report.docx                        # Documentation or report file on the pipeline
├── scripts/
│   ├── config_master.sh               # Script to configure the K8s master node
│   └── launch_jobs.sh                 # Script to launch training and selection jobs
├── self-hosted-runner/
│   ├── docker-compose.yml             # Docker Compose configuration for self-hosted runner
│   ├── Dockerfile                     # Dockerfile for self-hosted runner setup
│   └── start.sh                       # Script to start the self-hosted runner

```


## Project Overview
### Workflow

#### Training: 
The train.py script in the pythonscripts/ directory trains a model using specified hyperparameters. Training jobs are Dockerized and can be run on Kubernetes, with results saved for evaluation.

#### Model Selection: 
The select_best_model.py script evaluates trained models and selects the one with the best performance metrics, saving it to persistent storage for deployment.

#### Deployment: 
The selected model is deployed using Kubernetes configuration files in the k8s/ directory. It includes a load-balancer-service.yaml file to expose the service externally and hpa-config.yaml for autoscaling configurations.

### Key Components
#### Dockerfiles:
The dockerfiles/ directory contains Dockerfiles for each phase (training, selection, and deployment), ensuring each task has isolated dependencies and environments.

#### Kubernetes Configurations:
YAML files in k8s/ define deployment, services, persistent storage, and autoscaling configurations to create a resilient and scalable environment.

#### Python Scripts:
The core scripts under pythonscripts/ include model training (train.py), model selection (select_best_model.py), and model serving (serve_model.py). Dependency requirements for each stage are specified in separate requirements-*.txt files.

#### Self-Hosted Runner:
The self-hosted-runner/ directory contains files to set up a GitHub Actions self-hosted runner using Docker Compose, allowing CI/CD workflows to execute on a dedicated machine.


## Usage Instructions
### Prerequisites
* Kubernetes cluster with access credentials
* Docker and Docker Compose installed
* Persistent storage set up in the Kubernetes cluster
* GitHub Actions enabled for CI/CD (or configure for self-hosted runner)
* Running the Pipeline
* Build and Push Docker Images: Build the Docker images using the provided Dockerfiles and push them to a container registry (e.g., GitHub Container Registry).
* Deploy on Kubernetes: Apply the Kubernetes configurations (k8s/) to deploy, configure the load balancer, and set up autoscaling for the services.
* Trigger Training and Model Selection Jobs: Use launch_jobs.sh to initiate training jobs on Kubernetes. Once complete, run select_best_model.py to determine the best-performing model.
* Serve the Model: Deploy the selected model using the serve_model.py script within the Kubernetes environment, accessible through the load balancer service.

### Environment Variables Setup
To set up this pipeline, you’ll need to define several environment variables in GitHub Secrets. These variables provide authentication credentials and configuration details for Kubernetes, Docker, and GitHub.

#### Steps to Set Up GitHub Secrets
- Go to your GitHub repository.
- Navigate to Settings > Secrets and Variables > Actions.
- Click on "New repository secret" and create each of the following variables with the associated values.

### Required Secrets
#### Kubernetes Secrets
 K8S_CLUSTER_NAME: The name of your Kubernetes cluster. 
   + How to Obtain: This is usually set when creating a Kubernetes cluster, or you can     retrieve it using 
   ``` kubectl config get-contexts  ``` and noting the cluster name.

K8S_NAMESPACE: The namespace in Kubernetes where resources should be deployed.
+ How to Set: Choose or create a namespace in your cluster for this deployment, e.g., 
``` kubectl create namespace <namespace-name>. ```

K8S_SERVER: The API server endpoint for your Kubernetes cluster.
+ How to Obtain: 
``` kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}' to get the server URL.  ```

KUBE_CONFIG_DATA: The base64-encoded content of your Kubernetes config file (~/.kube/config), which provides access credentials to your cluster.
+ How to Create: Run the following command to encode the file:

```
cat ~/.kube/config | base64 | tr -d '\n'

```
```You can find two samples of kube configs as k8s/KUBE_CONFIG_DATA-certificate-based-sample.yaml, a Sample K8s config (certificate-based auth) and k8s/KUBE_CONFIG_DATA-token-based-sample.yaml a Sample K8s config (token-based auth) ```


#### Docker and GitHub Container Registry Secrets
DOCKER_USERNAME
+ Description: Your Docker Hub or GitHub Container Registry username.
+ How to Obtain: Use your Docker Hub or GitHub account username.

DOCKER_TRAIN_IMAGE, COMPARISION_DOCKER_IMAGE, DEPLOYMENT_DOCKER_IMAGE
+ Description: Names for the Docker images used in different stages of the pipeline.
+ How to Set: Define each name (e.g., myrepo/train-image) based on your image organization on Docker Hub or GitHub Container Registry.

GITHUB_TOKEN
+ Description: GitHub provides this default token for authentication within GitHub Actions.
+ How to Use: GitHub automatically generates this token in workflows; no setup is required, but you can create a personal access token if additional permissions are needed.

```
## Setting Up Environment Variables

To replicate the pipeline, define the following secrets in GitHub:

| Variable                   | Description                                         |
|----------------------------|-----------------------------------------------------|
| `K8S_CLUSTER_NAME`         | The Kubernetes cluster name.                        |
| `K8S_NAMESPACE`            | The Kubernetes namespace for deployment.            |
| `K8S_SERVER`               | The Kubernetes API server endpoint.                 |
| `KUBE_CONFIG_DATA`         | Base64-encoded Kubernetes config file content.      |
| `DOCKER_USERNAME`          | Docker Hub/GitHub Container Registry username.      |
| `DOCKER_TRAIN_IMAGE`       | Docker image name for training jobs.                |
| `COMPARISION_DOCKER_IMAGE` | Docker image name for model comparison jobs.        |
| `DEPLOYMENT_DOCKER_IMAGE`  | Docker image name for deployment jobs.              |
| `GITHUB_TOKEN`             | GitHub token for authentication.                    |
```
```
### Steps to Retrieve and Encode Kubernetes Config
1. Run the following command to get the base64-encoded Kubernetes config:
   cat ~/.kube/config | base64 | tr -d '\n'
```

## Contributing
Contributions are welcome. Feel free to submit issues or pull requests to enhance this project.
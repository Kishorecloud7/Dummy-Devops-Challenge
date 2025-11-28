

<h1> DevOps Challenge — Secure-Boot Initiative </h1>

<h2>Scenario</h2> 

* You are the First DevOps Engineer at a Security-First Software startup. The Development team has created a Minimal Python API.

 <h2>Objective </h2>

* To Containerize the Given application, 
* Provision the necessary infrastructure, 
* Deploy it using modern standards, and 
* Automate the build process. 


<h2> Prerequisites </h2>

* **Docker**
* **kubectl configured to a local cluster (kind, minikube, or Docker Desktop)**
* **Helm 3**
* **Terraform >= 1.3.0**
* **jq (for system-checks.sh)**
* **(Optional) kind or minikube to simplify local image loading**

<h2> Quick start (local) </h2>

<h3>1. Build, Provision and Deploy:</h3>

```
chmod +x setup.sh system-checks.sh
./setup.sh
```

<h3>2. Run Validation:</h3>

```
./system-checks.sh
```

<h2>How I solved the "Port 80 vs Non-Root" challenge</h2>

* Containers cannot run as root (requirement). Binding to port 80 normally requires root. There are two safe ways to allow a non-root process to bind to port 80:

* Assign the kernel capability CAP_NET_BIND_SERVICE to the container’s process (this allows binding to ports <1024 without running as root).

* Other options (less desirable): reverse proxy owned by root, port redirection, or setcap on the Python binary inside the image. I used the Kubernetes-native approach by adding NET_BIND_SERVICE to the container securityContext.capabilities.add so the container process runs as runAsUser: 1001 (non-root) and still binds to port 80. The filesystem is readOnlyRootFilesystem: true and ephemeral write needs are provided by mounting /tmp as an emptyDir.


<h2>Files & structure</h2>

```
/ 
├── app/                 
├── helm/                
├── terraform/           
├── .github/workflows/   
├── Dockerfile           
├── setup.sh             
├── system-checks.sh     
└── README.md            
```

<h2>Screenshots</h2>

Please find the screenshots/ directory in the repo showing:

kubectl get pods -n devops-challenge

helm status devops-challenge -n devops-challenge

terraform apply summary

system-checks output



---

<h2> 3. How to Run (step by step) </h2>

1. Ensure you have Docker and kubectl pointing to a local cluster (kind/minikube/Docker Desktop). If you use kind:

```
   - `kind create cluster`
```

2. Build & Deploy:

```
   - `chmod +x setup.sh system-checks.sh`
   - `./setup.sh`
```

3. Validate:

```
   - `./system-checks.sh`
```

<h2> Conclusion </h2>

* This Repository showcases my ability to Design and Implement a fully Automated, Secure, and Production-oriented DevOps pipeline.  

* Every part of the challenge — from running a non-root container on port 80, enforcing Kubernetes security standards, using Terraform for infrastructure as code, and setting up CI — is implemented with clarity and scalability in mind.

* The Project demonstrates not just Technical execution, but also an understanding of DevOps Principles such as Automation, Security-by-default, Reproducibility, and Observability.  

* I am Confident that the patterns used here can be extended into Real- world Production environments and improved further with Monitoring, Alerting, and GitOps practices.


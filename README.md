# web-autoheal
This project sets up a small, highly available web tier in **Azure** using **Terraform**.   It runs NGINX on a **VM Scale Set** behind a **Load Balancer** so that if one VM goes down, another one takes over automatically. 

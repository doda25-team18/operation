### Week Q2.1 (Nov 10+)

No work

### Week Q2.2 (Nov 17+)

- Diana:
    - https://github.com/doda25-team18/operation/pull/1

    I have worked on A1 (F7), where I created a `docker-compose` file to run the application and a `README` with instructions.

- Fedor
    - https://github.com/doda25-team18/model-service/pull/4

    My job in A1 was implementing 2 workflows (for the app and model-service repositories) to automate the release of docker container images. All requested parts mentioned under F8 have been implemented (with the version being determined by the 
    <version> in the pom.xml file in both workflows).
- Samuel
    - https://github.com/doda25-team18/lib-version/pull/7
      
    This week I worked on A1, dockerizing frontend and backend (including flexible containers and multi-stage images). I also implemented the automatic version-bumping behavior of the release workflow in lib-version.

- Jan: https://github.com/doda25-team18/model-service/pull/5  
  I have implemented features F1 (app uses lib-version dependency and shows its version) and 
  F10 (model is downloaded and used from volume mount instead of being hardcoded).

- Yasar
    - https://github.com/doda25-team18/lib-version/pull/6
    This week I implemented features F2 and F11 for A1.

- Sanjay
      - https://github.com/doda25-team18/model-service/blob/main/.github/workflows/train.yml
      - Implemented F9 for A1
  
### Week Q2.3 (Nov 24+)

- Yasar
    - https://github.com/doda25-team18/operation/pull/
    
    This week I completed Steps 1 through 4 of the Kubernetes cluster assignment.

- Diana
    - https://github.com/doda25-team18/operation/pull/15

    This week I worked on A2, where I did the steps from 8 to 12. In this I managed `etc/hosts/`, I added the Kubernetes repository, I installed the K8 tools, I configured `containerd` and I started and enabled `kubelet`.

- Fedor
    - https://github.com/doda25-team18/operation/pull/20

    This week I completed steps 13 to 17, including optional step 17. These steps involved initialising a kubernetes cluster, setting up kubectl, creating a pod network and installing Helm alongside an additional Helm package.

- Jan
  - https://github.com/doda25-team18/operation/pull/12

    I have worked on A2 and implemented steps 5-7. (disable swap, load br_netfilter and overlay
    modules, enable ipv4 forwarding)
https://github.com/doda25-team18/operation/pull/65
- Sanjay
  - https://github.com/doda25-team18/operation/pull/27
  - Worked on Steps 18-19

- Samuel
  - https://github.com/doda25-team18/operation/pull/28

      I worked on A2 and implemented step 20, which sets up Metallb.

### Week Q2.4 (Dec 1+)

- Samuel
    - https://github.com/doda25-team18/app/pull/5

      I worked on A3. I added a metrics endpoint to app, where 3 app-specific metrics can be pulled by Prometheus.

- Diana
    - https://github.com/doda25-team18/operation/pull/30
 
      This week I worked on A3, on Prometheus monitoring support.

- Jan
  - https://github.com/doda25-team18/operation/pull/12
    I have worked on A3 - Kubernetes Usage. I implemented requirements for Excellent, and
    fixed/implemented some of the requirements for Good.

- Fedor
  - [https://github.com/doda25-team18/operation/pull/34](https://github.com/doda25-team18/operation/pull/32)
    I have worked on A3 - Grafana. This part is still work in progress, with the current issue being Prometheus giving the error "Error scraping target: expected a valid start token, got "\n" ("INVALID") while parsing: "\n"". I also updated the readme with instructions on how to run the app without using minikube tunnel
- Yasar 
  - [https://github.com/doda25-team18/operation/pull/29] I have worked on A3 - Kubernetes Usage. I implemented requirements for sufficient, and
      implemented some of the requirements for Good.

### Week Q2.5 (Dec 8+)

- Yasar
  - [https://github.com/doda25-team18/operation/pull/37]
  This week I worked on A4 - Istio Traffic Management. I implemented complete Istio Service Mesh traffic management including Gateway and VirtualServices, 90/10 canary release traffic split with DestinationRules, consistent version routing (v1->v1, v2->v2), and sticky sessions using consistentHash cookies. All criteria for Excellent (9-10) have been implemented and tested.


- Fedor
  - [https://github.com/doda25-team18/operation/pull/39]
  THis week I worked on A4 - specifically, the Continuous Experimentation part. I have written the JavaScript/Python/CSS code for the new feature (update: this code has been deleted alongside the PR, and as it was replaced by better code later on) and created documentation for it. I am also working on the metrics for said feature.

- Jan
  - [https://github.com/doda25-team18/operation/pull/40]
  This week I worked on A4 - Additional Istio use case. I implemented global and per-user rate
    limiting.

- Samuel
  - https://github.com/doda25-team18/operation/pull/36
  This week I wrote an extension proposal as part of week 4. It explains the need for Automated Acceptance Testing and an example of an implementation approach.

- Diana
  - https://github.com/doda25-team18/operation/pull/38
  This week I wrote the deployment documentation for our project from A4.

- Sanjay
  - https://github.com/doda25-team18/operation/pull/41
  - Worked on Documentation for continuous experimentation

### Week Q2.6 (Dec 15+)
- Fedor
  - https://github.com/doda25-team18/operation/pull/43
  - Documentation now better structured, also mentions all the requirements stated in the instruction paragraph in the A4 assignment
- Jan
  - https://github.com/doda25-team18/operation/pull/42
  - This week I reviewed the feedback for A1 and implemented missing requirements
- Samuel
  - https://github.com/doda25-team18/operation/pull/44
  - This week I continued working on A2, implementing step 21

### Week Q2.7 (Jan 5+)

- Yasar
  - [https://github.com/doda25-team18/operation/pull/45]
  - This week I worked on A2 Step 23 (Istio Installation).
  
- Jan
  - https://github.com/doda25-team18/operation/pull/46
  - This week I implemented Prometheus alerts for A3 – excellent.

- Fedor
  - https://github.com/doda25-team18/operation/pull/47
  - This week I updated the document for cont exp and created the suitable dashboard to assist in the decision making process
  
- Diana
  - https://github.com/doda25-team18/operation/pull/48
  - This week, I worked on the Grafana dashboards from A3 - excellent.

- Samuel
  - https://github.com/doda25-team18/operation/pull/49
  - This week I worked on A2 and completed step 22 of the provisioning

### Week Q2.8 (Jan 12+)

- Jan
  - https://github.com/doda25-team18/operation/pull/51
  - This week I added a fix for alertmanager, I added a fix for vagrant hostnames issue and I made
    all VMs mount the same VB folder feature

- Yasar
  - https://github.com/doda25-team18/operation/pull/50
  - Fixed A2 Step 23 (Istio provisioning): removed auto-finalization from Vagrantfile, added architecture detection for Istio download (arm64/amd64 support). Done with help of Claude Code.
  - https://github.com/doda25-team18/operation/pull/52
  - Optimized vagrant up speed: combined apt package installations into single call, replaced slow Helm apt repository with direct binary download, added architecture detection for Helm. Done with help of Claude Code.

- Samuel
  - https://github.com/doda25-team18/operation/pull/53
  - I worked on A2 and implemented various optimizations for the different ansible playbooks, including speedups, local file versions of kubectl .yml files, fixing all ansible warnings (internal warnings are now suppressed as well)


- Fedor
  - https://github.com/doda25-team18/app/pull/7
  - This week I re-did the accuracy score counter feature, as the other approach was flawed and didn't work properly

- Diana
  - https://github.com/doda25-team18/operation/pull/54
  - This week I worked on A4, where I finished the deployment documentation. I added three diagrams and also finished writing some missing parts.

### Week Q2.9 (Jan 19+)

- Jan
  - https://github.com/doda25-team18/operation/pull/56
  - This week I fixed a bug in finalization.yml and switched from Mailhog to Mailpit for alert
    delivery. Also I improved READMEs

- Yasar
  - https://github.com/doda25-team18/operation/pull/58
  - Completed A4 Continuous Experimentation: Added v2 canary deployment (deployment-app-v2.yaml) for A/B testing, enabling 90/10 traffic split between stable (v1) and canary (v2) versions. Updated values.yaml with canary configuration and fixed v1 deployment labels/selectors. Also added screenshot of decision dashboard to documentation.

- Diana
  - https://github.com/doda25-team18/operation/pull/59
  - Added the dashboard of the continuous experimentation to Grafana, added more panels to the Grafana basic metrics dashboard, fixed some gramatical mistakes in the `continous-experimentation.md`.

### Week @2.10 (Jan 26+)

- Samuel
  - https://github.com/doda25-team18/operation/pull/65
  - This week I worked on A3/A4. I implemented a prerelease hostname that always routes to the canary host, ignoring the 90/10 split. I also improved the continuous experimentation dashboard. It now separates the relevant metric based on the deployed version (stable vs canary), creating 1 graphs we can compare. I also documented this dashboard.
 
- Fedor
  - https://github.com/doda25-team18/operation/pull/67
  - Some minor final changes for the documentation (both deployment and continuous experimentation)

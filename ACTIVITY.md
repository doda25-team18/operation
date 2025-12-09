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
-Yasar

### Week Q2.4 (Dec 8+)

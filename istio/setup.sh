# Amazon EKS Cluster w/ Istio
#Requirement for Istio
https://istio.io/latest/docs/ops/deployment/requirements/

#Download Istio Package
#https://istio.io/latest/docs/setup/getting-started/#download

1- curl -L https://istio.io/downloadIstio | sh -

#download a specific version or to override the processor architecture
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.21.1 TARGET_ARCH=x86_64 sh -

#Move to the Istio package directory. For example, if the package is istio-1.21.1:

2- cd istio-1.21.1

#Add the istioctl client to your path (Linux or macOS):

3- export PATH=$PWD/bin:$PATH

# Instaling Istio
1- istioctl install --set profile=demo -y

#Add a namespace label to instruct Istio to automatically 
# inject Envoy sidecar proxies when you deploy your application later:

2- kubectl label namespace default istio-injection=enabled

# Deploy applications
wget https://raw.githubusercontent.com/istio/istio/release-1.21/samples/bookinfo/platform/kube/bookinfo.yaml

kubectl apply -f bookinfo.yaml


# Check for Service and pods

3- kubectl get services, pods

#Verify everything is working correctly up
#HTML pages by checking for the page title in the response

4-kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"

#Open the application to outside traffic
#To make it accessible, you need to create an Istio Ingress Gateway,
# which maps a path to a route at the edge of your mesh
#deploy App Sample

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.21/samples/bookinfo/networking/bookinfo-gateway.yaml


# Ensure that there are no issues with the configuration:
5-istioctl analyze

# Execute the following command to determine 
# if your Kubernetes cluster is running in an environment 
# that supports external load balancers

6- kubectl get svc istio-ingressgateway -n istio-system

+++++++++++++++++++++++++++++++++++++

#Set the ingress IP and ports:

export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')


#Use the following command to correct the INGRESS_HOST value
export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# Follow these instructions if your environment does not have an external 
#load balancer and choose a node port instead.

export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')






+++++++++++++++++++++++++++++++++++++


#Run the following command to retrieve the external address of the

echo "http://$GATEWAY_URL/productpage"

#pods must have the NET_ADMIN and NET_RAW capabilities allowed



#To list the capabilities for a service account, replace <your namespace> and <your service account>
for psp in $(kubectl get psp -o jsonpath="{range .items[*]}{@.metadata.name}{'\n'}{end}"); do if [ $(kubectl auth can-i use psp/$psp --as=system:serviceaccount:<your namespace>:<your service account>) = yes ]; then kubectl get psp/$psp --no-headers -o=custom-columns=NAME:.metadata.name,CAPS:.spec.allowedCapabilities; fi; done

#check for the default service account in the default namespace, run the following command
for psp in $(kubectl get psp -o jsonpath="{range .items[*]}{@.metadata.name}{'\n'}{end}"); do if [ $(kubectl auth can-i use psp/$psp --as=system:serviceaccount:default:default) = yes ]; then kubectl get psp/$psp --no-headers -o=custom-columns=NAME:.metadata.name,CAPS:.spec.allowedCapabilities; fi; done




    -------------------View the dashboard-----------------------------------------
# Install Kiali and the other addons and wait for them to be deployed.
kubectl apply -f samples/addons
kubectl rollout status deployment/kiali -n istio-system

#Access the Kiali dashboard.
istioctl dashboard kiali




#To send a 100 requests to the productpage service, use the following command:

for i in $(seq 1 100); do curl -s -o /dev/null "http://$GATEWAY_URL/productpage"; done


# Add Monitoring
for ADDON in kiali jaeger prometheus grafana
do
    ADDON_URL="https://raw.githubusercontent.com/istio/istio/release-1.20/samples/addons/$ADDON.yaml"
    kubectl apply -f $ADDON_URL
done


# GRAFANA SET UP
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.21/samples/addons/grafana.yaml




    ------------------------------------------------------------


    # Uninstall
    kubectl delete -f samples/addons
    istioctl uninstall -y --purge

    kubectl delete namespace istio-system

    kubectl label namespace default istio-injection-



# Enabling the Certificate and IAM Policy on a managed cluster

The instruction [here](https://www.ibm.com/support/knowledgecenter/SSFC4F_1.1.0/manage_policies/) describe how to define a Certificate Policy, IAM Policy and others.  However, prior to create such policies, you need to ensure that the right components are deployed on the **managed cluster**. 

The instructions here will guide you through the configuration required to ensure MCM automatically configures all required components.  

The high-level steps are:  
  
1. Create namespace on the hub cluster.
2. Create namespace, SCC and Secrets on the managed cluster.  
3. Setup the service account on the managed cluster with the right privilege.  
4. Deploy cert-manager and iam-controller as a managed application on MCM Hub Cluster.  

## Adjusting the scripts  
  
At the moment you will need to manually adjust a few files before proceeding.
  
1.  Modifying 03-apps/00-channel.yaml
    You will need to replace the `<<ICP CONSOLE URL>>` with the value of your ICP URL and then you will need to base64 encode your CP4MCM UserId and Password and replace the tokens `<<SOME BASE64 USER>>` and `<<SOME BASE64 PASSWORD>>`

2. Modifying subscription files `02-cert-subscription.yaml` and `03-iam-subscription.yaml`
    You will need to modify `<<YOUR IMAGE REGISTRY>>` with your OCP image registry route, omitting the `https://`.


## Setting the tags against the clusters  
  
From the menu `Automate Infrastructure -> Clusters`, modify your clusters label to add:
Key: `managed-cluster` Value: `true` for managed cluster
Key: `hub-cluster` Value: `true` for mcm cluster

Implication here is that you imported your MCM cluster as part of the list of managed clusters.

## Commands to run

1. Setup Policies  
    With KUBECONFIG pointing to your **hub** cluster run:  
  
    ```
    oc apply -f 00-policies
    ```

2. Generate Image Registry Secret file
    With KUBECONFIG pointing to your **hub** cluster run:  
    
    ```
    cd 01-serviceaccount
    ./generateSecret.sh  <<Image-registry URL including HTTPS>>
    ```
    Should generate a file called image-pull-secret.yaml.  Edit and remove the unwanted fields.


3. Upload the image secret to all your managed clusters
    With KUBECONFIG pointing to your **managed** cluster run: 
    ```
    ./patchAccount.sh 
    ```
    
4. Deploy the managed applications
    With KUBECONFIG pointing to your **hub** cluster run:  
    ```
    cd ..
    oc apply -f 02-apps
    ```
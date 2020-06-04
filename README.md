# Enabling the Certificate and IAM Policy on a managed cluster

The instruction [here](https://www.ibm.com/support/knowledgecenter/SSFC4F_1.1.0/manage_policies/) describe how to define a Certificate Policy, IAM Policy and others.  However, prior to create such policies, you need to ensure that the right components are deployed on the **managed cluster**. 

The instructions here will guide you through the configuration required to ensure MCM automatically configures all required components.  

The high-level steps are:  
  
1. Create namespace on the hub cluster.
2. Create namespace, SCC and Secrets on the managed cluster.  
3. Setup the service account on the managed cluster with the right privilege.  
4. Deploy cert-manager and iam-controller as a managed application on MCM Hub Cluster.  
5. Patch the ClusterRole to ensure cert-manager has the required access.  

## Commands to run

1. Setup Policies  
    With KUBECONFIG pointing to your **hub** cluster run:  
  
    ```
    oc apply -f 00-policies
    ```

2. Patch Service Accounts
    With KUBECONFIG pointing to your **managed** cluster run:  
    
    ```
    ./01-serviceaccount/patchAccount.sh
    ```

3. Deploy the managed applications
    With KUBECONFIG pointing to your **hub** cluster run:  
    
    ```
    oc apply -f 03-apps
    ```

4. Patch Cluster Roles
    With KUBECONFIG pointing to your **managed** cluster run:  
    
    ```
    ./04-clusterrole/patchClusterRole.sh
    ```
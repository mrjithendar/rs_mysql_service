pipeline {

    agent any

    environment {
        tfDir = "terraform"
        region = "us-east-1"
        AWSCreds = credentials('awsCreds')
        AWS_ACCESS_KEY_ID = "${AWSCreds_USR}"
        AWS_SECRET_ACCESS_KEY = "${AWSCreds_PSW}"
        AWS_DEFAULT_REGION = "us-east-1"
        AWS_ACCOUNT_ID = "826334059644"
        vault = credentials('vaultToken')
        tfvars = "vars/${params.Options}.tfvars"
        eks_cluster_name = "roboshop-eks-cluster-demo"
        service = "mysql_demo"
    }

    stages {

        stage ('EKS Acthenticate') {
            steps {
                sh "aws eks update-kubeconfig --region ${AWS_DEFAULT_REGION} -name ${eks_cluster_name}"
            }
        }
    }
}

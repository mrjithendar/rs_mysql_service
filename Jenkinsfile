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
        eks_cluster_name = "roboshop-eks-cluster-int"
    }

    stages {


        stage ('Docker Login') {
            steps {
                sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
            }
        }

        stage ('Build Docker Images') {
            stage ("Build mysql Docker Image") {
                    steps {
                        dir("Docker/mysql") {
                            sh "docker build -t roboshop-mysql-int ."
                            sh "docker tag roboshop-mysql-int:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/roboshop-mysql-int:latest"
                            sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/roboshop-mysql-int:latest"
                    }
                }
            }
        }
    }
}
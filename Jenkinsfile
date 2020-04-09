pipeline{
    agent any
    stages {
        stage('build') {
            steps{
                sh './mvnw package'
            }
        }
        stage('release') {
            steps{
                rtUpload (
                serverId: 'artifactory-1',
                spec: '''{
                    "files": [
                        {
                        "pattern": "target/*.jar",
                        "target": "maven-artifacts/"
                        }
                    ]
                    }'''
                )
                rtPublishBuildInfo (
                    serverId: 'artifactory-1'
                )
            }
        }

        stage('deploy'){
            steps{
                //deploy to app-vm
                withCredentials([usernamePassword(credentialsId:'79590f1b-45a9-4ed6-ad8f-ea87d033efe3', passwordVariable: 'PASSWORD', usernameVariable: 'SSH_CRED')]) {
                    sh 'sshpass -p ${PASSWORD} ssh ${SSH_CRED} "docker-compose down"'
                    sh 'sshpass -p ${PASSWORD} scp docker-compose.yml Dockerfile target/*.jar ${SSH_CRED}:~/'
                    sh 'sshpass -p ${PASSWORD} ssh ${SSH_CRED} "docker build . -t petclinic:v${env.BUILD_NUMBER}"'
                    sh 'sshpass -p ${PASSWORD} ssh ${SSH_CRED} "docker tag petclinic:v${env.BUILD_NUMBER} dockerregistrycicd.azurecr.io/petclinic:v${env.BUILD_NUMBER}"'
                    sh 'sshpass -p ${PASSWORD} ssh ${SSH_CRED} "docker push dockerregistrycicd.azurecr.io/petclinic:v${env.BUILD_NUMBER}"'
                    sh 'sshpass -p ${PASSWORD} ssh ${SSH_CRED} "docker rmi dockerregistrycicd.azurecr.io/petclinic:v${env.BUILD_NUMBER}"'
                    sh 'sshpass -p ${PASSWORD} ssh ${SSH_CRED} "docker-compose up -d"'
                }
            }
        }
    }
}
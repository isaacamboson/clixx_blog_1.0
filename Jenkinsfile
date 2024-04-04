pipeline {
    agent any
    environment {
        PATH = "${PATH}:${getTerraformPath()}"
    }

    stages{
        stage('Initial Deployment Approval') {
              steps {
                script {
                def userInput = input(id: 'confirm', message: 'Start Pipeline?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: true, description: 'Start Pipeline', name: 'confirm'] ])
             }
           }
        }

         stage('terraform init'){
             steps {
                slackSend (color: '#FFFF00', message: "STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
                sh "terraform init"
             }
         }


         stage('terraform plan'){
            steps {
                // sh "terraform plan --auto-approve"
                sh "terraform plan -out=tfplan -input=false"
            }
        }

         stage('Final Deployment Approval') {
            steps {
                script {
                    def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: true, description: 'Apply terraform', name: 'confirm'] ])
                }
            }
         }

        stage('Terraform Apply'){
            steps {
                sh "terraform ${ACTION} --auto-approve"
                //  sh "terraform apply  -input=false tfplan"
            }
        }

        // stage('Terraform Destroy'){
        //     steps {
        //          sh "terraform destroy -auto-approve"
        //     }
        // }
    }
}

def getTerraformPath(){
        def tfHome = tool name: 'terraform-40', type: 'terraform'
        return tfHome
}

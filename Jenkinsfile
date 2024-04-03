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
                 sh "terraform init"
             }
         }

         stage('terraform destroy'){
            steps {
                 sh "terraform destroy -auto-approve"
            }
        }

        //  stage('terraform plan'){
        //     steps {
        //          sh "terraform plan -out=tfplan -input=false"
        //     }
        // }

        //  stage('Final Deployment Approval') {
        //     steps {
        //         script {
        //             def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
        //         }
        //     }
        //  }

        // stage('Terraform Apply'){
        //     steps {
        //          sh "terraform apply  -input=false tfplan"
        //     }
        // }
    }
}

def getTerraformPath(){
        def tfHome = tool name: 'terraform-40', type: 'terraform'
        return tfHome
}

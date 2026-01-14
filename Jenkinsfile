pipeline {
  agent any

  parameters {
    choice(name: 'TEST_SET', choices: ['SmokeTests', 'AllTests'], description: 'Choose which tests to run')
  }

  environment {
    SCHEME = "SQMAAssignments"
    DESTINATION = "platform=iOS Simulator,name=iPhone 16,OS=latest"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Xcode Version') {
      steps {
        sh 'xcodebuild -version'
      }
    }

    stage('Run Tests') {
      steps {
        sh '''
          set -euo pipefail

          xcodebuild \
            -scheme "$SCHEME" \
            -testPlan "$TEST_SET" \
            -destination "$DESTINATION" \
            -derivedDataPath DerivedData \
            clean test | tee xcodebuild.log
        '''
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'xcodebuild.log', allowEmptyArchive: true
    }
  }
}
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

    stage('Detect Xcode project/workspace') {
      steps {
        sh '''
          set -euo pipefail
          echo "Repo root content:"
          ls -la

          echo "Searching for Xcode project/workspace..."
          WORKSPACE_PATH=$(find . -maxdepth 5 -name "*.xcworkspace" | head -n 1 || true)
          PROJECT_PATH=$(find . -maxdepth 5 -name "*.xcodeproj" | head -n 1 || true)
          PACKAGE_PATH=$(find . -maxdepth 5 -name "Package.swift" | head -n 1 || true)

          if [ -n "$WORKSPACE_PATH" ]; then
            echo "FOUND_WORKSPACE=$WORKSPACE_PATH" | tee xcode_path.env
          elif [ -n "$PROJECT_PATH" ]; then
            echo "FOUND_PROJECT=$PROJECT_PATH" | tee xcode_path.env
          elif [ -n "$PACKAGE_PATH" ]; then
            echo "FOUND_PACKAGE=$PACKAGE_PATH" | tee xcode_path.env
          else
            echo "ERROR: No .xcworkspace, .xcodeproj, or Package.swift found."
            exit 2
          fi

          cat xcode_path.env
        '''
      }
    }

    stage('Run Tests') {
      steps {
        sh '''
          set -euo pipefail
          source xcode_path.env

          if [ -n "${FOUND_WORKSPACE:-}" ]; then
            xcodebuild \
              -workspace "$FOUND_WORKSPACE" \
              -scheme "$SCHEME" \
              -testPlan "$TEST_SET" \
              -destination "$DESTINATION" \
              -derivedDataPath DerivedData \
              clean test | tee xcodebuild.log

          elif [ -n "${FOUND_PROJECT:-}" ]; then
            xcodebuild \
              -project "$FOUND_PROJECT" \
              -scheme "$SCHEME" \
              -testPlan "$TEST_SET" \
              -destination "$DESTINATION" \
              -derivedDataPath DerivedData \
              clean test | tee xcodebuild.log

          elif [ -n "${FOUND_PACKAGE:-}" ]; then
            # Swift Package (no Xcode project)
            swift test | tee xcodebuild.log
          fi
        '''
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'xcodebuild.log', allowEmptyArchive: true
      archiveArtifacts artifacts: 'xcode_path.env', allowEmptyArchive: true
    }
  }
}
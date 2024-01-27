pipeline {
  environment {
    PUSH_CREDS = credentials('codeberg_push')
    DOCKER_SERVER = "codeberg.org/nohoster"
    ARCH = "linux/arm64,linux/amd64"
  }
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: docker
            command:
            - cat
            tty: true
            volumeMounts:
             - mountPath: /var/run/docker.sock
               name: docker-sock
          volumes:
            hostPath:
              path: /var/run/docker.sock    
        '''
    }
  }
  stages {
    stage('Git clone') {
        steps {
            container('docker') {
                git branch: 'main',changelog: false, credentialsId: 'codeberg_read', poll: false, url: 'https://codeberg.org/nohoster/breezewiki.git'
            }
        }
    }
    stage('Docker buildx') {
      steps {
          container('docker') {
            sh 'docker buildx create --name mybuilder --use --bootstrap'
            sh 'docker buildx build --push --platform linux/amd64,linux/arm64 -t $DOCKER_SERVER/breezewiki:$(date +%d%m%y) .'
            sh 'docker buildx build --push --platform linux/amd64,linux/arm64 -t $DOCKER_SERVER/breezewiki:latest .'
          }
      }
    }
  }
}

